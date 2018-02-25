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
            
            let loginAlert = UIAlertController(title: "Error", message: "There was an error logging in, please check details", preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            loginAlert.addAction(loginAction)
            
            self.present(loginAlert, animated: true, completion: nil)
            
        } else {
            
            let emailLogin = nameLoginTxtField.text
            
            //for member they do not need email, they simply put in their first name and it'll append it to a login email, password will be generic too
        }
        
        if nameLoginTxtField.text == "Admin" {
            
            performSegue(withIdentifier: "AdminInterface", sender: nil)
            
        } else if nameLoginTxtField.text == "Member" {
            
            performSegue(withIdentifier: "MemberInterface", sender: nil)
            
        } else if nameLoginTxtField.text == "Artist" {
            
            performSegue(withIdentifier: "GroupList", sender: nil)
            
        } else if nameLoginTxtField.text == "Buddy" {
            
            performSegue(withIdentifier: "NameList", sender: nil)
            
        } else {
            
            print("ERROR LOGGING IN")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    

    


}

