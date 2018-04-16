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
    
    var userName: Users {
        get {
            return _userName
        } set {
            _userName = newValue
        }
    }
    
    let passwordResetIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    
    @IBOutlet weak var buddyLbl: UILabel!
    @IBOutlet weak var typePicker: UIPickerView!
    
    var typePickerData: [String] = [String]()
    
    @IBOutlet weak var emailTxtField: UITextField!
    
    @IBOutlet weak var nameTxtField: UITextField!
    
    @IBOutlet weak var groupPicker: UIPickerView!
    
    var groupPickerData: [String] = [String]()
    
    @IBOutlet weak var buddyPicker: UIPickerView!
    
    var buddyPickerData: [String] = [String]()
    
    override func viewDidLoad() {
        
        nameLbl.text = userName.userName
        
        gatherUserDetails(user: userName.userName)
        
        typePicker.delegate = self
        typePicker.dataSource = self
        groupPicker.delegate = self
        groupPicker.dataSource = self
        buddyPicker.delegate = self
        buddyPicker.dataSource = self
        
        typePickerData = ["Member of Artlink", "Buddy", "Artist"]
        
    }
    
    func gatherUserDetails(user: String) {
        
        let groupReference = Database.database().reference().child("groups")
        
        groupReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
        
                
                for groupsNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let groupElement = groupsNameJSON.value as? [String: AnyObject]
                    let groupElementName = groupElement!["Group"] as! String

                    
                    self.groupPickerData.append(groupElementName)
                    
                }
            }
        }
        
        
        
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    let typeName = memberElement?["Type"] as! String
                    let userName = memberElement?["Name"] as! String
                    //let groupName = memberElement?["Group"] as! String
                    //let buddyName = memberElement?["Buddy"] as! String
                    self.email = memberElement?["Email"] as! String
                
                    if typeName == "Buddy" {
                        self.buddyPickerData.append(userName)
                    }
                    
                    //TODO: Make starting element in picker what user has stored
                    
                    if user == userName {
                        
                        
                        if typeName == "Member of Artlink" {
                            
                            self.emailTxtField.isHidden = true
                            self.emailLbl.isHidden = true
                            self.typeLbl.isHidden = true
                            self.typePicker.isHidden = true
                            
                        } else {
                            
                            self.buddyPicker.isHidden = true
                            self.buddyLbl.isHidden = true
                            self.typeLbl.isHidden = true
                            self.typePicker.isHidden = true
                            
                        }
                        
                        self.resetPasswordEmail = self.email
                        self.nameTxtField.text = userName
                        self.emailTxtField.text = self.email
                        
                    }
                    
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
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
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
    
    
    
    
    
    
    
    
}
