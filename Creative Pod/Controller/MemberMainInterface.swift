//
//  MemberMainInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MemberMainInterface: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    @IBAction func viewDesigns(_ sender: Any) {
        
        performSegue(withIdentifier: "MemberViewDesign", sender: nil)
        
    }
    
    @IBAction func createDesign(_ sender: Any) {
        
        performSegue(withIdentifier: "MembersCreate", sender: nil)
        
    }
    
    
    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //if let destination = segue.destination as? MembersCreativePieces {
            
            //if let user = sender as? Users {
                
                //destination.userName  = user
                
            //}
        //}
        
    //}
    
    
    @IBAction func loggingOut(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            dismiss(animated: true, completion: nil)
            
            print("Sign out successful")
            
        } catch {
            print("Logout Error")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

