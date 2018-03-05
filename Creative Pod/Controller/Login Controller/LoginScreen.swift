//
//  ViewController.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginScreen: UIViewController {
    
    
    @IBOutlet weak var nameLoginTxtField: UITextField!
    
    @IBOutlet weak var passwordLoginTxtField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func loggingIn(_ sender: Any) {
        
        
        if nameLoginTxtField.text == "" || passwordLoginTxtField.text == "" {
            
            let loginAlert = UIAlertController(title: "Error", message: "There was an error logging in, please do not leave text field blank", preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            loginAlert.addAction(loginAction)
            
            self.present(loginAlert, animated: true, completion: nil)
            
        } else {
            
            let nameField = "\(nameLoginTxtField.text!)@artlink.co.uk"
            
            Auth.auth().signIn(withEmail: nameField, password: self.passwordLoginTxtField.text!, completion: { (user, error) in
                
                if error == nil {
                    
                    //observe single event means we dont register each time
                    Database.database().reference().child("users/\(user!.uid)/Type").observe(.value, with: { (snapshot) in
   
                        switch snapshot.value as! String {
                            
                        case "Member of Artlink":
                            self.performSegue(withIdentifier: "MemberInterface", sender: nil)
                        case "Artist":
                            self.performSegue(withIdentifier: "GroupList", sender: nil)
                        case "Buddy":
                            self.performSegue(withIdentifier: "NameList", sender: nil)
                        case "Admin":
                            self.performSegue(withIdentifier: "AdminInterface", sender: nil)
                        default:
                            
                            let loginAlert = UIAlertController(title: "Error", message: "Couldn't find user type", preferredStyle: .alert)
                            
                            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
                            loginAlert.addAction(loginAction)
                            
                            self.present(loginAlert, animated: true, completion: nil)
                            
                        }
                        
                        
                    })
                    
                } else {
                    
                    let loginAlert = UIAlertController(title: "Error", message: "There was an error logging in, please check details", preferredStyle: .alert)
                    
                    let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    loginAlert.addAction(loginAction)
                    
                    self.present(loginAlert, animated: true, completion: nil)
                    
                }
                
            })
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("User is signed in.")
            } else {
                print("User is signed out.")
            }
        }
        
        nameLoginTxtField.text = ""
        passwordLoginTxtField.text = ""
        

    }
    

    


}
