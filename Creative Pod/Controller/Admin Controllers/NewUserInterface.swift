//
//  EditingUserGroupInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//


import UIKit
import FirebaseDatabase
import Firebase

/*
 
    @brief This class determines behaviour of the NewUserInterface.swift interface used by an Admin.
 
 */


class NewUserInterface: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Initialisation of variables and components to be used
    
    @IBOutlet weak var buddyLbl: UILabel!
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    var typePickerData: [String] = [String]()
    
    @IBOutlet weak var groupPicker: UIPickerView!
    
    var groupPickerData: [String] = [String]()  

    @IBOutlet weak var buddyPicker: UIPickerView!
    
    var buddyPickerData: [String] = [String]()

    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    var type: String = ""
    var name: String = ""
    var email: String = ""
    var groupName: String = ""
    var buddyName: String = ""
    var nameEmailField: String = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setting delegates to ensure pickers can be interacted with.
        
        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        self.groupPicker.delegate = self
        self.groupPicker.dataSource = self
        self.buddyPicker.delegate = self
        self.buddyPicker.dataSource = self
        
        //Calling necessary functions so data is inputted into pickers before view loads.
        downloadBuddyDetails()
        downloadGroupDetails()
        
        typePickerData = ["Member of Artlink", "Buddy", "Artist"]
        
        
    }
    
    //Downloads all groups within 'groups' branch and places within the UIPickerView
    
    func downloadGroupDetails() {
        
        let groupReference = Database.database().reference().child("groups")
        
        groupReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.groupPickerData.removeAll()
                
                for groupJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //TODO: May need to separate the model out into different users?
                    let groupElement = groupJSON.value as? [String: AnyObject]
                    let groupName = groupElement?["Group"]
                    
                    self.groupPickerData.append(groupName as! String)
                    
                }
                
            }
        }
    
    }
    
    //Downloads all buddy name's within 'users' branch and places within the UIPickerView.

    func downloadBuddyDetails() {
        
        let buddyReference = Database.database().reference().child("users")
        
        buddyReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.buddyPickerData.removeAll()
                
                for buddyJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let buddyElement = buddyJSON.value as? [String: AnyObject]
                    let buddyName = buddyElement?["Name"]
                    let typeName = buddyElement?["Type"]
                    
                    if typeName as! String == "Buddy" {
                        
                        self.buddyPickerData.append(buddyName as! String)
                        
                    } else {
                        
                        continue
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    //Decides how many columns for the UIPickerView's
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //As more than one UIPickerView used, each was assigned a tag and using tags places correct data into correct picker.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if pickerView.tag == 1 {
            return typePickerData.count
        } else if pickerView.tag == 2 {
            return groupPickerData.count
        } else {
            return buddyPickerData.count
        }
        
    }
    
    //Inputs the data within the UIPickerView.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return typePickerData[row]
        } else if pickerView.tag == 2 {
            return groupPickerData[row]
        } else {
            return buddyPickerData[row]
        }
    }
    
    //Depending on what type of Member an Admin wishes to create, show particular fields that should be inputted with data.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            
            let typeValue = typePickerData[row] as String
            
            if  typeValue == "Artist" || typeValue == "Buddy"{
                
                buddyPicker.isHidden = true
                buddyLbl.isHidden = true
                emailLbl.isHidden = false
                emailTxtField.isHidden = false
                
                //Assign picked data into another variable to be used for uploading to database.
                type = typeValue
                
            } else if typeValue == "Member of Artlink" {
                
                buddyPicker.isHidden = false
                buddyLbl.isHidden = false
                emailLbl.isHidden = true
                emailTxtField.isHidden = true
                
                //Assign picked data into another variable to be used for uploading to database.
                type = typeValue
            
            } else {
                return
            }
            
        } else if pickerView.tag == 2 {
            
            //Assign picked data into another variable to be used for uploading to database.
            let groupValue = groupPickerData[row] as String
            groupName = groupValue
            
        } else if pickerView.tag == 3 {
            
            if buddyPicker.isHidden == true {
                buddyName = ""
            } else {
                
                //Assign picked data into another variable to be used for uploading to database.
                let buddyValue = buddyPickerData[row] as String
                buddyName = buddyValue
            }
            
        } else {
            return
        }
        
        
        
    }
    
    //When save button is clicked, take all data inserted into the fields and data chosen from UIPickerViews and create a new user and upload their information to the database.
    
    @IBAction func saveChangesBtn(_ sender: Any) {
        
        //Check to see if fields are empty.
        
        if nameTxtField.text == "" || passwordTxtField.text == "" {
            
            let loginAlert = UIAlertController(title: "Error", message: "There was an creating a user, please do not leave text field blank", preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            loginAlert.addAction(loginAction)
            
            self.present(loginAlert, animated: true, completion: nil)
            
        } else {
            
            //If not empty, depending on what value was type of user was selected by Admin create their user.
            if type == "Member of Artlink" {
                
                nameEmailField = "\(nameTxtField.text!)@artlink.co.uk"
                email = ""
                
            } else {
                
                nameEmailField = self.emailTxtField.text!
                email = nameEmailField
                
            }
            
            let passwordField = "\(passwordTxtField.text!)"
            
            //Authenticate user with email or name provided.
            
            Auth.auth().createUser(withEmail: nameEmailField, password: passwordField, completion: { (user, error) in
                
                //Check to see if password is legit over 6 character which is required for firebase.
                
                if passwordField.count > 6 {
                    
                    if error == nil {
                        
                        let name = self.nameTxtField.text
                    
                        //Initialise reference and update the values on 'users' branch by adding the new user
                        
                        let ref = Database.database().reference()
                        let usersRef = ref.child("users")
                        let usersUIDRef = usersRef.child((user?.uid)!)
                        let values = ["Type": self.type, "Name": name, "Group": self.groupName, "Buddy": self.buddyName, "Email": self.email]
                        usersUIDRef.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                            
                            if error == nil {
                                
                            } else {
                                
                                print(error!)
                                
                            }
                            
                            
                        })
                        
                        
                    } else {
                        
                        //Alerts appearing is errors are encountered.
                        
                        let signupAlert = UIAlertController(title: "Error", message: "There was an error creating the user, please try again", preferredStyle: .alert)
                        
                        self.present(signupAlert, animated: true, completion: nil)
                    }
                } else {
                    
                    let passwordAlert = UIAlertController(title: "Error", message: "Password too short!", preferredStyle: .alert)
                    
                    let passwordAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    passwordAlert.addAction(passwordAction)
                    
                    self.present(passwordAlert, animated: true, completion: nil)
                    
                }
                
            
            })
            
        }
        
        //Delay initiated to ensure details are uploaded to the cloud before going back to previous interface.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}

