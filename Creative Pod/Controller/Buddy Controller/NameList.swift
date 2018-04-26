//
//  BuddyScreen.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

//Imported Libraries

import UIKit
import Firebase
import FirebaseDatabase

/*
 
 @brief This class determines behaviour of the NameList interface used by an Artist or a Buddy.
 
 */


class NameList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var membersTableView: UITableView!
    
    private var _groupName: Groups!
    
    @IBOutlet weak var backBtnName: UIButton!
    
    //Getter and Setter ensuring that a group name is recieved when arriving at the controller
    
    var groupName: Groups {
        get {
            return _groupName
        } set {
            _groupName = newValue
        }
    }
    
    //Initialisation of empty variables to be assigned when data is downloaded.
    
    let currentUser = Auth.auth().currentUser?.uid
    var name: String = ""
    var group: String = ""
    var typeName: String = ""
    var membersBuddyName: String = ""
    var membersName: String = ""
    var membersTypeName: String = ""
    var membersGroupName: String = ""
    
    var membersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        membersTableView.delegate = self
        membersTableView.dataSource = self
        
        readUserData()
        
    }
    
    //Function that reads User data from Realtime Database.
    
    func readUserData() {
        
        //Creates reference to where logged in users data is held within database.
        
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child((Auth.auth().currentUser?.uid)!)
        
        //Observes data assigning it to previously initialised variables
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //Retrieves data of logged in user
            let type = snapshot.value as? [String: AnyObject]
            self.typeName = type!["Type"] as! String
            self.name = type!["Name"] as! String
            self.group = type!["Group"] as! String
        }
        
        //Uses reference of database to read all user data from Realtime Database.
        
        currentUserReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.membersArray.removeAll()
                
                for memberJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let memberElement = memberJSON.value as? [String: AnyObject]
                    self.membersBuddyName = memberElement?["Buddy"] as! String
                    self.membersName = memberElement?["Name"] as! String
                    self.membersTypeName = memberElement?["Type"] as! String
                    self.membersGroupName = memberElement?["Group"] as! String
                    
                    //Depending on the type of User that is currently logged in it assigns particular variables. This is because more than one type of user can use this interface.
                    
                    //If Buddy, display Members they are responsible for.
                    
                    if self.typeName == "Buddy" && self.name == self.membersBuddyName && self.membersTypeName == "Member of Artlink" {
                        
                        let nameListMember = Users(typeOfUser: self.membersTypeName, userName: self.membersName, groupName: self.membersGroupName)
                        
                        self.membersArray.append(nameListMember)
                        
                        self.backBtnName.setTitle("LOG OUT", for: .normal)
                        
                        //If Artist, display group Members
                        
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
    
    
    //Initialises the data that should be inserted into the rows of the TableView calling methods from NameListCell.swift
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Ensures rows are recycled.
        
        if let cell = membersTableView.dequeueReusableCell(withIdentifier: "NameListCell", for: indexPath) as? NameListCell {
            
            let memberName = membersArray[indexPath.row]
            
            cell.updateUI(usersName: memberName)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    //Determines how many rows are placed within TableViews, in this case the length of both group and stories array.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return membersArray.count
        
    }
    
    //Movement to a different Controller performed when selecting a row from either TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memberName = membersArray[indexPath.row]
        
        performSegue(withIdentifier: "ViewMemberArtwork", sender: memberName)
        
    }
    
    //Prepares data to be transfered to next Controller when moving between Controllers.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MembersCreativePieces {
            
            if let member = sender as? Users {
                
                destination.userName = member
                destination.viewControllerCameFrom = "NameList"
            }
        }
    
    }
    
    //Determines if a user is logged out if current user is a Buddy using the interface, or movement to previous screen if Artist using interface.

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
