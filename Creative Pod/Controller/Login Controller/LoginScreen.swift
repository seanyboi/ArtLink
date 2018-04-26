//
//  ViewController.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

//Imported Libraries

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

/*
    @brief This class determines behaviour of the Login Interface
 
 */

class LoginScreen: UIViewController, UITextFieldDelegate {
    
    //Initialisation of components
    
    @IBOutlet weak var nameLoginTxtField: UITextField!
    
    @IBOutlet weak var passwordLoginTxtField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Associating the text fields with the controller so keyboard can be moved to manouveur between textfields
        
        nameLoginTxtField.delegate = self
        passwordLoginTxtField.delegate = self
        nameLoginTxtField.tag = 1
        passwordLoginTxtField.tag = 2
        nameLoginTxtField.returnKeyType = UIReturnKeyType.next
        passwordLoginTxtField.returnKeyType = UIReturnKeyType.done
        
        //Clears any data cached within setting file that is used when creating stories.
        
        if let clearUserDefaults = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: clearUserDefaults)
        }
        
        //Listens to state of User to determine if logged in or logged out
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("User is signed in.")
            } else {
                print("User is signed out.")
            }
        }
        
    }
    
    //When login button is clicked checks are made to determine which Controller a User should navigate to.
    
    @IBAction func loggingIn(_ sender: Any) {
        
        //Check to see if textfields are empty.
        
        if nameLoginTxtField.text == "" || passwordLoginTxtField.text == "" {
            
            //Initialises and displays an alert message if textfields are empty.
            
            let loginAlert = UIAlertController(title: "Error", message: "There was an error logging in, please do not leave text field blank", preferredStyle: .alert)
            
            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            loginAlert.addAction(loginAction)
            
            self.present(loginAlert, animated: true, completion: nil)
            
        } else {
            
            //Firstly checks if it a user logging in is a Member just using their name and appends to <@artlink.co.uk>.
            
            let nameField = "\(nameLoginTxtField.text!)@artlink.co.uk"
            
            //Auth library checks if user is authenticated within Firebase.
            
            Auth.auth().signIn(withEmail: nameField, password: self.passwordLoginTxtField.text!, completion: { (user, error) in
                
                //If there is no error returned, check what the User's type is.
                
                if error == nil {
                    
                    //Checks the type key of each child within the 'users' branch observing single event so we dont register new data each time.
                
                    Database.database().reference().child("users/\(user!.uid)/Type").observe(.value, with: { (snapshot) in
                        
                        //Switch statement checking the type and performing segue's dependent on the Users type.
                
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
                            
                            //If there is an error within database where a type hasnt been registered, display error message.
                            
                            let loginAlert = UIAlertController(title: "Error", message: "Couldn't find user type", preferredStyle: .alert)
                            
                            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            
                            loginAlert.addAction(loginAction)
                            
                            self.present(loginAlert, animated: true, completion: nil)
                            
                        }
                        
                        
                    })
                    
                } else {
                    
                    //If the authentication fails by trying to append <@artlink.co.uk>, try with what is placed within the textfield by the user and proceed with authentication
                    
                    //Used for Artists or Buddy's mainly
                    
                    Auth.auth().signIn(withEmail: self.nameLoginTxtField.text!, password: self.passwordLoginTxtField.text!,
                                       completion: { (user, error) in
                                        if error == nil {
                                            
                                            
                                            //Observe single event from Database means we dont register each time.
                                            
                                            Database.database().reference().child("users/\(user!.uid)/Type").observe(.value, with: { (snapshot) in switch snapshot.value as! String {
                                                
                                                //Precautionary check of users type again
                                                
                                            case "Member of Artlink":
                                                self.performSegue(withIdentifier: "MemberInterface", sender: nil)
                                            case "Artist":
                                                self.performSegue(withIdentifier: "GroupList", sender: nil)
                                            case "Buddy":
                                                self.performSegue(withIdentifier: "NameList", sender: nil)
                                            case "Admin":
                                                self.performSegue(withIdentifier: "AdminInterface", sender: nil)
                                            default:
                                                
                                                //Displaying of error message if user type cannot be found
                                                
                                                let loginAlert = UIAlertController(title: "Error", message: "Couldn't find user type", preferredStyle: .alert)
                                                let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                                loginAlert.addAction(loginAction)
                                                self.present(loginAlert, animated: true, completion: nil)
                                                                                                                        }
                                            })
                                            
                                        } else {
                                            
                                            //Any further errors logging in are presented with this error message.
                                            
                                            let loginAlert = UIAlertController(title: "Error", message: "There was an error logging in, please check details", preferredStyle: .alert)
                                            
                                            let loginAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                            
                                            loginAlert.addAction(loginAction)
                                            
                                            self.present(loginAlert, animated: true, completion: nil)
                                            
                                        }
                                        
                    })
                    
                }
                
            })
            
        }
        
    }
    
    //Allows movement between textfields using keyboard return button.
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == nameLoginTxtField {
            textField.resignFirstResponder()
            passwordLoginTxtField.becomeFirstResponder()
        } else if textField == passwordLoginTxtField {
            textField.resignFirstResponder()
        }
        
        return true
        
    }
    
    
    
}


