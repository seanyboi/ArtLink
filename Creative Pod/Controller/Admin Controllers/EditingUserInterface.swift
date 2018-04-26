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

class EditingUserInterface: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    private var _userName: Users!
    
    var resetPasswordEmail: String = ""
    var email: String = ""
    var adaptedBuddy: String = ""
    
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
    
    var buddyPickerData = [String]()
    var arrayOfUsers = [String]()
    var buddyMemberDictionary : [String : String] = [:]
    var userGroupDictionary : [String : String] = [:]
    var userTypeDictionary : [String : String] = [:]
    
    @IBOutlet weak var passwordStack: UIStackView!
    
    override func viewDidLoad() {
        
        userNameDefined = userName.userName
        
        nameLbl.text = userName.userName
        
        gatherUserDetails(user: userName.userName)
        
        groupPicker.delegate = self
        groupPicker.dataSource = self
        buddyPicker.delegate = self
        buddyPicker.dataSource = self
        
    }
    
    func gatherUserDetails(user: String) {
        
        let groupReference = Database.database().reference().child("groups")
        
        groupReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                for groupsNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let groupElement = groupsNameJSON.value as? [String: AnyObject]
                    let groupElementName = groupElement!["Group"] as! String
                    self.groupPickerData.append(groupElementName)
                    print("THIS IS THE GROUPS: \(groupElementName)")
                    
                }
            }
        }
        
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
                    
                    print(typeName)
                    
                    self.userGroupDictionary[userNameX] = groupName
                    self.userTypeDictionary[userNameX] = typeName
                    
                    if typeName == "Buddy" {
                        
                        print("I AM IN THE BUDDY STATEMENT")
                        self.buddyPickerData.append(userNameX)
                        print("THIS IS BUDDY DATA: \(self.buddyPickerData)")
                    
                    } else if typeName == "Member of Artlink" {
                        
                        self.buddyMemberDictionary[userNameX] = buddyName
                        self.arrayOfUsers.append(userNameX)
                        
                    }
                    
            
                }
                
                    if self.arrayOfUsers.contains(user) && self.userTypeDictionary[user] == "Member of Artlink" {
                        
                        print("THIS IS USERNAME: \(user)")
                        
                        self.passwordStack.isHidden = true
                        
                        let buddyIndex = self.buddyPickerData.index(of: self.buddyMemberDictionary[user]!)
                        
                        self.buddyPicker.selectRow(buddyIndex!, inComponent: 0, animated: true)
                        
                        self.passwordStack.isHidden = true
                
                        self.resetPasswordEmail = self.email
                        self.nameTxtField.text = user
                        let groupIndex = self.groupPickerData.index(of: self.userGroupDictionary[user]!)
                        self.groupPicker.selectRow(groupIndex!, inComponent:0, animated:true)
                    
                    } else {
                        
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
    
    
    @IBAction func resetPasswordEmailBtn(_ sender: Any) {
        
        passwordResetIndicator.color = .black
        
        passwordResetIndicator.center = self.view.center
        
        let transformation: CGAffineTransform = CGAffineTransform(scaleX: 3.0, y: 3.0)
        passwordResetIndicator.transform = transformation
        
        self.view.addSubview(passwordResetIndicator)
        
        passwordResetIndicator.startAnimating()
        
        Auth.auth().sendPasswordReset(withEmail: self.resetPasswordEmail) { (error) in
            
            if error == nil {
                
                print("Reset email for password sent")
                self.passwordResetIndicator.stopAnimating()
                
            } else {
                
                self.passwordResetIndicator.stopAnimating()
                
                let unsuccessfulEmail = UIAlertController(title: "Error", message: "Email Could Not Be Delivered, Please Try Again", preferredStyle: .alert)
                
                let emailAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                unsuccessfulEmail.addAction(emailAction)
                
            }
            
        }
        
        
        
    }
    
    
    @IBAction func saveChangesBtnPressed(_ sender: Any) {
        
        let membersReference = Database.database().reference().child("users")
        
        let selectedGroupPicker = self.groupPickerData[self.groupPicker.selectedRow(inComponent: 0)]
        print(selectedGroupPicker)
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    let userName = memberElement?["Name"] as! String
                    let typeName = memberElement?["Type"] as! String
                    
                    switch typeName {
                        
                    case "Member of Artlink":
                        
                        if userName == self.userNameDefined {
                            
                            let selectedBuddyPicker = self.buddyPickerData[self.buddyPicker.selectedRow(inComponent: 0)]
                            print(selectedBuddyPicker)
                            
                            membersReference.updateChildValues([membersJSON.key : ["Buddy" : selectedBuddyPicker, "Email" : "", "Group" : selectedGroupPicker , "Name" : self.nameTxtField.text!, "Type" : "Member of Artlink"]])
                            
                        } else {
                            continue
                        }
                        
                    case "Artist":
                        
                        if userName == self.userNameDefined {
                            membersReference.updateChildValues([membersJSON.key : ["Buddy" : "", "Email" : self.email, "Group" : selectedGroupPicker , "Name" : self.nameTxtField.text!, "Type" : "Artist"]])
                            
                        } else {
                            continue
                        }
                        
                    case "Buddy":
                        
                        if userName == self.userNameDefined {
                            
                            if (self.nameTxtField.text == nil)  {
                                
                                print("text boxes must contain strings")
                                
                            } else {
                                
                                membersReference.updateChildValues([membersJSON.key : ["Buddy" : "", "Email" : self.email, "Group" : selectedGroupPicker, "Name" : self.nameTxtField.text!, "Type" : "Buddy"]])
                                
                                let memberOfArtlinkReference = Database.database().reference().child("users")
                                
                                memberOfArtlinkReference.observe(DataEventType.value) { (snapshot) in
                                    if snapshot.childrenCount > 0 {
                                        
                                        for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                            
                                            let memberElement = membersJSON.value as? [String: AnyObject]
                                            let userName2 = memberElement?["Name"] as! String
                                            let typeName2 = memberElement?["Type"] as! String
                                            let buddyName2 = memberElement?["Buddy"] as! String
                                            let groupName2 = memberElement?["Group"] as! String
                                            
                                            print(typeName2)
                                            print(self.userNameDefined)
                                            
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 2 {
            return groupPickerData.count
        } else {
            return buddyPickerData.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 2 {
            return groupPickerData[row]
        } else {
            return buddyPickerData[row]
        }
    }
    
    
    
    
    
    
    
    
}
