//
//  EditingUserGroupInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//


import UIKit
import FirebaseDatabase
import Firebase



class EditingUserGroupInterface: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var buddyLbl: UILabel!
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    var typePickerData: [String] = [String]()
    
    @IBOutlet weak var groupPicker: UIPickerView!
    
    var groupPickerData: [String] = [String]()

    @IBOutlet weak var buddyPicker: UIPickerView!
    
    var buddyPickerData: [String] = [String]()

    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
    var type: String = ""
    var name: String = ""
    var groupName: String = ""
    var buddyName: String = ""
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        self.groupPicker.delegate = self
        self.groupPicker.dataSource = self
        self.buddyPicker.delegate = self
        self.buddyPicker.dataSource = self
        
        let buddyReference = Database.database().reference().child("users")
        
        buddyReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.buddyPickerData.removeAll()
                
                for buddyJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //TODO: May need to separate the model out into different users?
                    let buddyElement = buddyJSON.value as? [String: AnyObject]
                    let buddyName = buddyElement?["Name"]
                    let typeName = buddyElement?["Type"]
                    print(typeName!)
                    
                    if typeName as! String == "Buddy" {
                        
                        self.buddyPickerData.append(buddyName as! String)
                        
                    } else {
                        
                        //TODO: Change Error
                        print("ERROR")
                        
                    }
                    
                }
    
            }
        }
        
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

        typePickerData = ["Member of Artlink", "Buddy", "Artist"]
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if pickerView.tag == 1 {
            return typePickerData.count
        } else if pickerView.tag == 2 {
            return groupPickerData.count
        } else {
            return buddyPickerData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return typePickerData[row]
        } else if pickerView.tag == 2 {
            return groupPickerData[row]
        } else {
            return buddyPickerData[row]
        }
    }
    
    //TODO: If picker isn't moved then first element isnt selected!
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 1 {
            
            let typeValue = typePickerData[row] as String
            
            if  typeValue == "Artist" || typeValue == "Buddy"{
                
                buddyPicker.isHidden = true
                buddyLbl.isHidden = true
                type = typeValue
                
            } else if typeValue == "Member of Artlink" {
                
                buddyPicker.isHidden = false
                buddyLbl.isHidden = false
                type = typeValue
            
            } else {
                return
            }
            
        } else if pickerView.tag == 2 {
            
            let groupValue = groupPickerData[row] as String
            groupName = groupValue
            
        } else if pickerView.tag == 3 {
            
            if buddyPicker.isHidden == true {
                buddyName = ""
            } else {
                let buddyValue = buddyPickerData[row] as String
                buddyName = buddyValue
            }
            
        } else {
            return
        }
        
        
        
    }
    
    
    @IBAction func saveChangesBtn(_ sender: Any) {
        
        if nameTxtField.text == "" || passwordTxtField.text == "" {
            
            let loginAlert = UIAlertController(title: "Error", message: "There was an creating a user, please do not leave text field blank", preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            loginAlert.addAction(loginAction)
            
            self.present(loginAlert, animated: true, completion: nil)
            
        } else {
            
            let nameEmailField = "\(nameTxtField.text!)@artlink.co.uk"
            let passwordField = "\(passwordTxtField.text!)"
            
            Auth.auth().createUser(withEmail: nameEmailField, password: passwordField, completion: { (user, error) in
                
                if passwordField.count > 6 {
                    if error == nil {
                        
                        let name = self.nameTxtField.text
                        
                        let ref = Database.database().reference()
                        let usersRef = ref.child("users")
                        let usersUIDRef = usersRef.child((user?.uid)!)
                        let values = ["Type": self.type, "Name": name, "Group": self.groupName, "Buddy": self.buddyName]
                        usersUIDRef.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                            
                            if error == nil {
                                
                                print("Saved Succesfully into Realtime Database")
                            
                            } else {
                                
                                print(error!)
                                
                            }
                            
                            
                        })
                        
                        
                    } else {
                        
                        //TODO: this gets dismissed quickly, put a delay in possibly
                        let signupAlert = UIAlertController(title: "Error", message: "There was an error creating the user, please try again", preferredStyle: .alert)
                        
                        let signupAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        signupAlert.addAction(signupAction)
                        
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
        
        //TODO: put some clause into this
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            
            self.dismiss(animated: true, completion: nil)
        }
    
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
}

