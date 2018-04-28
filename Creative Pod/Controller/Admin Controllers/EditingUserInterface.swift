//
//  EditingUsers.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 08/03/2018.
//

//
//  EditingUsers.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 08/03/2018.
//

import UIKit
import FirebaseDatabase
import Firebase

/*
 
    @brief This class determines behaviour of the EditingUserInterface.swift interface used by an Admin
 
 */


class EditingUserInterface: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Initialisation of variables and components
    
    private var _userName: Users!
    
    var resetPasswordEmail: String = ""
    var email: String = ""
    var adaptedBuddy: String = ""
    
    //Getter and setter to ensure that a User is passed through to the interface.
    
    var userName: Users {
        get {
            return _userName
        } set {
            _userName = newValue
        }
    }
    
    let passwordResetIndicator = UIActivityIndicatorView()
    
    var userNameDefined: String = ""
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var buddyLbl: UILabel!
    
    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var groupPicker: UIPickerView!
    
    var groupPickerData: [String] = [String]()
    
    @IBOutlet weak var buddyPicker: UIPickerView!
    
    //Creation of arrays and dictionaries to help with editing of User
    
    var buddyPickerData = [String]()
    var arrayOfUsers = [String]()
    var buddyMemberDictionary : [String : String] = [:]
    var userGroupDictionary : [String : String] = [:]
    var userTypeDictionary : [String : String] = [:]
    
    @IBOutlet weak var passwordStack: UIStackView!
    
    override func viewDidLoad() {
        
        //Getting the User interface components.
        
        userNameDefined = userName.userName
        
        nameLbl.text = userName.userName
        
        gatherUserDetails(user: userName.userName)
        
        //Assigning delegates so they can be interacted with.
        
        groupPicker.delegate = self
        groupPicker.dataSource = self
        buddyPicker.delegate = self
        buddyPicker.dataSource = self
        
    }
    
    //Function to gather user details that Admin wishes to edit from Realtime Database.
    
    func gatherUserDetails(user: String) {
        
        //Creation of of reference and observation of data held within branch.
        
        let groupReference = Database.database().reference().child("groups")
        
        groupReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                //Looping through all children of branch inserting their values into the group UIPickerView.
                
                for groupsNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let groupElement = groupsNameJSON.value as? [String: AnyObject]
                    let groupElementName = groupElement!["Group"] as! String
                    self.groupPickerData.append(groupElementName)
                    
                }
            }
        }
        
        //Creation of of reference and observation of data held within branch.
        
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    let typeName = memberElement?["Type"] as! String
                    let userNameX = memberElement?["Name"] as! String
                    let groupName = memberElement?["Group"] as! String
                    let buddyName = memberElement?["Buddy"] as! String
                    self.email = memberElement?["Email"] as! String
                    
                    //Appending to previously created dictionary the User's name and their associated group, also the user's name and their associated type.
                    
                    self.userGroupDictionary[userNameX] = groupName
                    self.userTypeDictionary[userNameX] = typeName
                    
                    //If a Buddy type is encountered append their name to the Buddy UIPickerView.
                    if typeName == "Buddy" {
                        
                        self.buddyPickerData.append(userNameX)
                    
                    //If a Member of Artlink type is encountered, add their name and their associated buddy to the dictionary and append the user to the user's array.
                    } else if typeName == "Member of Artlink" {
                        
                        self.buddyMemberDictionary[userNameX] = buddyName
                        self.arrayOfUsers.append(userNameX)
                        
                    }
                    
            
                }
                
                //If the user's array contains the selected user to edit name and their type is a Member, show particular components and set UIPickerView's to that user's data.
                    if self.arrayOfUsers.contains(user) && self.userTypeDictionary[user] == "Member of Artlink" {
                        
                        self.passwordStack.isHidden = true
                        
                        let buddyIndex = self.buddyPickerData.index(of: self.buddyMemberDictionary[user]!)
                        
                        self.buddyPicker.selectRow(buddyIndex!, inComponent: 0, animated: true)
                        
                        self.passwordStack.isHidden = true
                
                        self.resetPasswordEmail = self.email
                        self.nameTxtField.text = user
                        let groupIndex = self.groupPickerData.index(of: self.userGroupDictionary[user]!)
                        self.groupPicker.selectRow(groupIndex!, inComponent:0, animated:true)
                    
                    } else {
                        
                        //Setting data into components if not a Member.
                        self.buddyPicker.isHidden = true
                        self.buddyLbl.isHidden = true
                        
                        self.resetPasswordEmail = self.email
                        self.nameTxtField.text = user
                        let groupIndex = self.groupPickerData.index(of: self.userGroupDictionary[user]!)
                        self.groupPicker.selectRow(groupIndex!, inComponent:0, animated:true)
                    }
                
            }
        }
    }
    
    
    //When button is pressed, email is sent to User to reset their password. This feature is ONLY available to Artists and Buddy's who sign up with their emails.
    @IBAction func resetPasswordEmailBtn(_ sender: Any) {
        
        //Loading spinner until email has been successfully sent.
        
        passwordResetIndicator.color = .black
        
        passwordResetIndicator.center = self.view.center
        
        let transformation: CGAffineTransform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        passwordResetIndicator.transform = transformation
        
        self.view.addSubview(passwordResetIndicator)
        
        passwordResetIndicator.startAnimating()
        
        //Auth library allows email to be sent that is self made within the Firebase Platform.
        Auth.auth().sendPasswordReset(withEmail: self.resetPasswordEmail) { (error) in
            
            if error == nil {
                
                self.passwordResetIndicator.stopAnimating()
                
            } else {
                
                //Alert if email was not delivered successfully.
                
                self.passwordResetIndicator.stopAnimating()
                
                let unsuccessfulEmail = UIAlertController(title: "Error", message: "Email Could Not Be Delivered, Please Try Again", preferredStyle: .alert)
                
                let emailAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                unsuccessfulEmail.addAction(emailAction)
                
            }
            
        }
        
        
        
    }
    
    //When save button is pressed, data is updated within the database to match the Admins editing decisions.
    
    @IBAction func saveChangesBtnPressed(_ sender: Any) {
        
        //Creation of reference to the 'users' branch
        
        let membersReference = Database.database().reference().child("users")
        
        //Gathering selected group from UIPickerView
        
        let selectedGroupPicker = self.groupPickerData[self.groupPicker.selectedRow(inComponent: 0)]
        
        //Observe children from 'users' branch
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    let userName = memberElement?["Name"] as! String
                    let typeName = memberElement?["Type"] as! String
                
                    //Switch statement to determine actions taken when a member of a particular type is encountered.
                
                    switch typeName {
                        
                    //If a member and the selected user to edit is the same as the name, update their values accordingly.
                    case "Member of Artlink":
                        
                        if userName == self.userNameDefined {
                            
                            let selectedBuddyPicker = self.buddyPickerData[self.buddyPicker.selectedRow(inComponent: 0)]
                            
                            membersReference.updateChildValues([membersJSON.key : ["Buddy" : selectedBuddyPicker, "Email" : "", "Group" : selectedGroupPicker , "Name" : self.nameTxtField.text!, "Type" : "Member of Artlink"]])
                            
                        } else {
                            continue
                        }
                        
                    //If an artist and the selected user to edit is the same as the name, update their values accordingly.
                    case "Artist":
                        
                        if userName == self.userNameDefined {
                            membersReference.updateChildValues([membersJSON.key : ["Buddy" : "", "Email" : self.email, "Group" : selectedGroupPicker , "Name" : self.nameTxtField.text!, "Type" : "Artist"]])
                            
                        } else {
                            continue
                        }
                    //If a buddy and the selected user to edit is the same as the name, update their values accordingly. If a buddy is edited then we must edit name within member's branches.
                    case "Buddy":
                        
                        if userName == self.userNameDefined {
                            
                            if (self.nameTxtField.text == nil)  {
                                
                            } else {
                                
                                //Update buddy with new values
                                membersReference.updateChildValues([membersJSON.key : ["Buddy" : "", "Email" : self.email, "Group" : selectedGroupPicker, "Name" : self.nameTxtField.text!, "Type" : "Buddy"]])
                                
                                let memberOfArtlinkReference = Database.database().reference().child("users")
                                
                                //Update member's values with new buddy name!
                                memberOfArtlinkReference.observe(DataEventType.value) { (snapshot) in
                                    if snapshot.childrenCount > 0 {
                                        
                                        for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                            
                                            let memberElement = membersJSON.value as? [String: AnyObject]
                                            let userName2 = memberElement?["Name"] as! String
                                            let typeName2 = memberElement?["Type"] as! String
                                            let buddyName2 = memberElement?["Buddy"] as! String
                                            let groupName2 = memberElement?["Group"] as! String
                                            
                                            if typeName2 == "Member of Artlink" && buddyName2 == userName {
                                                
                                                membersReference.updateChildValues([membersJSON.key : ["Buddy" : self.nameTxtField.text!, "Email" : "", "Group" : groupName2, "Name" : userName2, "Type" : "Member of Artlink"]])
                                                
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                        } else {
                            continue
                        }
                        
                    case "Admin":
                        
                        continue
                        
                    default:
                        return
                    }
                    
                    
                }
            }
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //Setting number of columns for pickers.
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //Setting number of rows in pickers
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 2 {
            return groupPickerData.count
        } else {
            return buddyPickerData.count
        }
    }
    
    //Setting data within the pickers.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 2 {
            return groupPickerData[row]
        } else {
            return buddyPickerData[row]
        }
    }
    
    
    
    
    
    
    
    
}
