//
//  BuddyScreen.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit
import Firebase
import FirebaseDatabase

class NameList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var membersTableView: UITableView!
    
    private var _groupName: Groups!
    
    @IBOutlet weak var backBtnName: UIButton!
    
    var groupName: Groups {
        get {
            return _groupName
        } set {
            _groupName = newValue
        }
    }
    
    let currentUser = Auth.auth().currentUser?.uid
    //let currentUserReference = Database.database().reference().child("users")
    var name: String = ""
    var group: String = ""
    var typeName: String = ""
    var membersBuddyName: String = ""
    var membersName: String = ""
    var membersTypeName: String = ""
    var membersGroupName: String = ""
    
    //TODO: Logic to Present Correct Members
    
    var membersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child((Auth.auth().currentUser?.uid)!)
        
        print("CURRENT USER \(currentUser!)")
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //RETRIEVED CURRENT USERS NAME AND TYPE
            let type = snapshot.value as? [String: AnyObject]
            self.typeName = type!["Type"] as! String
            self.name = type!["Name"] as! String
            self.group = type!["Group"] as! String
        }
        
        currentUserReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.membersArray.removeAll()
                
                for memberJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let memberElement = memberJSON.value as? [String: AnyObject]
                    self.membersBuddyName = memberElement?["Buddy"] as! String
                    self.membersName = memberElement?["Name"] as! String
                    self.membersTypeName = memberElement?["Type"] as! String
                    self.membersGroupName = memberElement?["Group"] as! String
                    
                    if self.typeName == "Buddy" && self.name == self.membersBuddyName && self.membersTypeName == "Member of Artlink" {
                
                        let nameListMember = Users(typeOfUser: self.membersTypeName, userName: self.membersName, groupName: self.membersGroupName)
                        
                        self.membersArray.append(nameListMember)
                        
                        self.backBtnName.setTitle("LOG OUT", for: .normal)
                        
                    } else if self.typeName == "Artist" && self.groupName.groupName == self.membersGroupName && self.membersTypeName == "Member of Artlink" {
                    
                        let nameListMember = Users(typeOfUser: self.membersTypeName, userName: self.membersName, groupName: self.membersGroupName)
                        self.membersArray.append(nameListMember)
                        
                        self.backBtnName.setTitle("BACK", for: .normal)
                        
                    }
                
                }
                
                self.membersTableView.reloadData()
            }
        }
    
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = membersTableView.dequeueReusableCell(withIdentifier: "NameListCell", for: indexPath) as? NameListCell {
            
            let memberName = membersArray[indexPath.row]
            
            cell.updateUI(usersName: memberName)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return membersArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memberName = membersArray[indexPath.row]
        
        performSegue(withIdentifier: "ViewMemberArtwork", sender: memberName)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MembersCreativePieces {
            
            if let member = sender as? Users {
                
                destination.userName = member
                destination.viewControllerCameFrom = "NameList"
            }
        }
    
    }
    
    

    @IBAction func backBtnPresssed(_ sender: Any) {
        
        if typeName == "Buddy" {
            
            do {
                
                try Auth.auth().signOut()
                
                dismiss(animated: true, completion: nil)
                
                print("Sign out successful")
                
            } catch {
                print("Logout Error")
            }
        
        } else {
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
}
