//
//  ViewController.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit
import Firebase
import FirebaseAuth

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
                    
                    self.performSegue(withIdentifier: "AdminInterface", sender: nil)
                    print("successfully logged in")
                    
                } else {
                    
                    let loginAlert = UIAlertController(title: "Error", message: "There was an error logging in, please check details", preferredStyle: .alert)
                    
                    let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    loginAlert.addAction(loginAction)
                    
                    self.present(loginAlert, animated: true, completion: nil)
                    
                }
                
            })
            
            
            //for member they do not need email, they simply put in their first name and it'll append it to a login email, password will be generic too
            
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    


}

