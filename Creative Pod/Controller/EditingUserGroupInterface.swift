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
        
        typePickerData = ["Member of Artlink", "Buddy", "Artist"]
        groupPickerData = ["Project X", "Project Y", "Project Z"]
        buddyPickerData = ["Sean", "Max", "Joe"]
        
        
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
            
            let loginAlert = UIAlertController(title: "Error", message: "There was an error logging in, please do not leave text field blank", preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            loginAlert.addAction(loginAction)
            
            self.present(loginAlert, animated: true, completion: nil)
            
        } else {
            
            let nameEmailField = "\(nameTxtField.text!)@artlink.co.uk"
            let passwordField = "\(passwordTxtField.text!)"
            
            //checks that password is legit length (6), perform other checks such as surname etc
            Auth.auth().createUser(withEmail: nameEmailField, password: passwordField, completion: { (user, error) in
                
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
                    
                    let loginAlert = UIAlertController(title: "Error", message: "There was an error creating the user, please try again", preferredStyle: .alert)
                    
                    let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    loginAlert.addAction(loginAction)
                    
                    self.present(loginAlert, animated: true, completion: nil)
                }
                
                
            
            })
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

