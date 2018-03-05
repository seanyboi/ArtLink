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
    
    
    var memberName: String = ""
    var typeName: String = ""
    var groupName: String = ""
    
    var memberArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func viewDesigns(_ sender: Any) {
        
        self.memberArray.removeAll()
    
        let currentUserID = Auth.auth().currentUser?.uid
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child(currentUserID!)
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //RETRIEVED CURRENT USERS NAME AND TYPE
            let type = snapshot.value as? [String: AnyObject]
            self.typeName = type!["Type"] as! String
            self.memberName = type!["Name"] as! String
            self.groupName = type!["Group"] as! String
        
            let nameListMember = Users(typeOfUser: self.typeName, userName: self.memberName, groupName: self.groupName)

            self.memberArray.append(nameListMember)
            
            let memberName = self.memberArray.first
            
            self.performSegue(withIdentifier: "MemberViewDesign", sender: memberName)
            
        }
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let destination = segue.destination as? MembersCreativePieces {
    
            if let user = sender as? Users {
            
                destination.userName  = user
        }
    
        }
    }
    
    
    
    
    
    @IBAction func createDesign(_ sender: Any) {
        
        performSegue(withIdentifier: "MembersCreate", sender: nil)
        
    }
    
    

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

