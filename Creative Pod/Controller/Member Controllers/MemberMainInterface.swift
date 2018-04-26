//
//  MemberMainInterface.swift
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
 
 @brief This class determines behaviour of the MemberMainInterface interface used by an Member of Artlink.
 
 */


class MemberMainInterface: UIViewController {
    
    //Initialisation of empty variables
    
    var memberName: String = ""
    var typeName: String = ""
    var groupName: String = ""
    
    var memberArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //When button is pressed information of current user is read so it can be passed through to next Interface in order to see appropriate images for the associated Member.
    
    @IBAction func viewDesigns(_ sender: Any) {
        
        self.memberArray.removeAll()
        
        //Create reference to values to child node in database.
    
        let currentUserID = Auth.auth().currentUser?.uid
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child(currentUserID!)
        
        //Observe values
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //RETRIEVED CURRENT USERS NAME AND TYPE
            let type = snapshot.value as? [String: AnyObject]
            self.typeName = type!["Type"] as! String
            self.memberName = type!["Name"] as! String
            self.groupName = type!["Group"] as! String
            
            //Place within Users object
        
            let nameListMember = Users(typeOfUser: self.typeName, userName: self.memberName, groupName: self.groupName)

            self.memberArray.append(nameListMember)
            
            let memberName = self.memberArray.first
            
            self.performSegue(withIdentifier: "MemberViewDesign", sender: memberName)
            
        }
    
    }
    
    //Prepares data to be pass through to next Controller.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if let destination = segue.destination as? MembersCreativePieces {
    
            if let user = sender as? Users {
            
                destination.userName  = user
        }
    
        }
    }
    
    
    
    //When button is pressed continue to interface where a user can take a picture
    
    @IBAction func createDesign(_ sender: Any) {
        
        performSegue(withIdentifier: "MembersCreate", sender: nil)
        
    }
    
    
    //If successful log out then Member is navigates back to login screen.

    @IBAction func loggingOut(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            dismiss(animated: true, completion: nil)
            
            print("Sign out successful")
            
        } catch {
            print("Logout Error")
        }
        
    }
    
}

