//
//  EditingUserGroupInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//


import UIKit
import Firebase


class EditingUserGroupInterface: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    var typePickerData: [String] = [String]()
    
    @IBOutlet weak var groupPicker: UIPickerView!
    
    var groupPickerData: [String] = [String]()

    @IBOutlet weak var buddyPicker: UIPickerView!
    
    var buddyPickerData: [String] = [String]()

    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var passwordTxtField: UITextField!
    
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
            
            let pickedValue = typePickerData[row] as String
            
            if  pickedValue == "Artist" || pickedValue == "Buddy"{
                
                buddyPicker.isHidden = true
                
        } else if pickedValue == "Member of Artlink" {
                
                buddyPicker.isHidden = false
            
            
        } else {
                
                return
    
        }
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
            
            Auth.auth().createUser(withEmail: nameEmailField, password: passwordField, completion: { (user, error) in
                
                if error == nil {
                    
                    let ref = 
                    
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

