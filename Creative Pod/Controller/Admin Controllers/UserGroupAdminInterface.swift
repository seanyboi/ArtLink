//
//  UserGroupAdminInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//

//Imported Libraries

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

/*
 @brief This class determines behaviour of the UserGroupAdminInterface.swift interface used by an Admin
 
 */

class UserGroupAdminInterface: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Initialisation of variables and components.
    
    @IBOutlet weak var groupListTableView: UITableView!
    
    @IBOutlet weak var nameListTableView: UITableView!
    
    var usersArray = [Users]()
    var groupArray = [Groups]()
    
    var memberUID: String = ""
    var groupUID: String = ""
    var currentUserID: String = (Auth.auth().currentUser?.uid)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        nameListTableView.delegate = self
        nameListTableView.dataSource = self
        
        pullUserData()
        pullGroupData()
    
    }
    
    //Method that pulls all user data to be placed within User's TableView
    
    func pullUserData() {
        
        //Creates reference to 'users' branch
        
        let membersReference = Database.database().reference().child("users")
        
        //Observes values of 'users' branch
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.usersArray.removeAll()
                
                //Loops through child nodes extracting key and values
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    let typeName = memberElement?["Type"] as! String
                    let userName = memberElement?["Name"] as! String
                    let groupName = memberElement?["Group"] as! String
                    
                    //Appends every user to the users array except for the admin user account as this does not need to be displayed within the Admin interface.
                    
                    switch typeName {
                        
                    case "Member of Artlink":
                        let member = Users(typeOfUser: typeName, userName: userName, groupName: groupName)
                        self.usersArray.append(member)
                        
                    case "Artist":
                        let member = Users(typeOfUser: typeName, userName: userName, groupName: groupName)
                        self.usersArray.append(member)
                    
                    case "Buddy":
                        let member = Users(typeOfUser: typeName, userName: userName, groupName: groupName)
                        self.usersArray.append(member)
                        
                    case "Admin":
                        continue
                    
                    default:
                        return
                    }
        
                }
                
                self.nameListTableView.reloadData()
                
            }
        }
    }
    
    //Method that pulls all user data to be placed within Group TableView
    
    func pullGroupData() {
        
        //Creates reference to 'groups' branch in Database
        
        let groupReference = Database.database().reference().child("groups")
        
        //Observes values of 'groups' branch
        
        groupReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.groupArray.removeAll()
                
                ////Loops through child nodes extracting key and values
                
                for groupsNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let groupElement = groupsNameJSON.value as? [String: AnyObject]
                    let groupElementName = groupElement!["Group"]
                    let group = Groups(groupName: groupElementName as! String)
                    
                    //Appends to group array to be displayed within Groups TableView
                    
                    self.groupArray.append(group)
                    
                }
                
                self.groupListTableView.reloadData()
                
            }
        }
        
        
    }
    
    //Implementation of delete and edit user button appearing when swiping on a row in Users and Groups TableView

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Tags associated with tables, Group TableView = 1
        
        if tableView.tag == 1 {
            
            //Creates delete button when row is swiped
            
                let deletingGroup = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                    
                    
                        let groupOfDeletion = self.groupArray[indexPath.row]
                    
                        print(groupOfDeletion.groupName)
                    
                        //Removes group name from the TableView
                        
                        self.groupArray.remove(at: indexPath.row)
                        self.groupListTableView.deleteRows(at: [indexPath], with: .fade)
                    
                        //Creates reference to 'groups' branch
                        
                        let groupReference = Database.database().reference().child("groups")
                    
                        //Observes values within the branch
                        
                        groupReference.observe(DataEventType.value) { (snapshot) in
                            if snapshot.childrenCount > 0 {
                                
                                for groupsNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                    
                                    self.groupUID = groupsNameJSON.key
                                    
                                    let groupElement = groupsNameJSON.value as? [String: AnyObject]
                                    let groupElementName = groupElement!["Group"] as! String
                                    
                                    //If Group name that was swiped to be deleted is within the 'groups' branch then delete it from the TableView.
                                    if groupOfDeletion.groupName == groupElementName {
                                        
                                        groupReference.child(self.groupUID).removeValue()
                                        
                                        //Alert stating the group has been deleted.
                                        
                                        let deleteAlert = UIAlertController(title: "Group Deleted", message: "\(groupElementName) Has Been Deleted", preferredStyle: .alert)
                                        
                                        let deleteAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        
                                        deleteAlert.addAction(deleteAction)
                                        
                                        self.present(deleteAlert, animated: true, completion: nil)
                                        
                                    }
                                    
                                    
                                }
                                
                                self.groupListTableView.reloadData()
                                
                            }
                        }
                    }
            
                    return [deletingGroup]
            
                //Users TableView tag = 2
            
                } else if tableView.tag == 2 {
            
                    //Initialisation of delete button when swiping
            
                    let deletingUser = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
                        let nameOfDeletion = self.usersArray[indexPath.row]
                        
                        //Removal of User from User TableView
                        
                        self.usersArray.remove(at: indexPath.row)
                        self.nameListTableView.deleteRows(at: [indexPath], with: .fade)
                        
                        //Initialisation of reference of 'user' branch in database
                        
                        let membersReference = Database.database().reference().child("users")
                        
                        //Observing the values within the 'user' branch
                        
                        membersReference.observe(DataEventType.value) { (snapshot) in
                            if snapshot.childrenCount > 0 {
                                
                                //Looping through the values
                                
                                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                    
                                    self.memberUID = membersJSON.key
                                    
                                    let memberElement = membersJSON.value as? [String: AnyObject]
                                    let userName = memberElement?["Name"] as! String
                                    
                                    //If name of User swiped is within the database, delete all data associated with them.
                                    
                                    if nameOfDeletion.userName == userName {
                                        
                                        membersReference.child(self.memberUID).removeValue()
                                        
                                        //Present alert stating user has been deleted
                                        
                                        let deleteAlert = UIAlertController(title: "User Deleted", message: "\(userName) Has Been Deleted", preferredStyle: .alert)
                                        
                                        let deleteAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        
                                        deleteAlert.addAction(deleteAction)
                                        
                                        self.present(deleteAlert, animated: true, completion: nil)
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    }
            
                //Create a edit user button
            
                let editingUser = UITableViewRowAction(style: .normal, title: "Edit User") { (action, indexPath) in
                
                    //When pressed move to EditingUserInterface.swift interface
                    
                    let memberName = self.usersArray[indexPath.row]
                    self.performSegue(withIdentifier: "EditingUsers", sender: memberName)
                
                }
                    //Give button a green colour.
                    editingUser.backgroundColor = UIColor.green
            
                    return [deletingUser, editingUser]
                }
        
            return [UITableViewRowAction.init()]

        }
    
    //Determines how many rows are placed within TableViews, in this case the length of both group and users array.

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            
            return groupArray.count
            
        } else if tableView.tag == 2 {
            
            return usersArray.count
            
        } else {
            
            return 0
        }
        
    }
    
    //Initialises the data that should be inserted into the rows of the two TableViews calling methods from AdminGroupCell.swift and AdminUserCell.swift

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if tableView.tag == 1 {
        
            if let cell = groupListTableView.dequeueReusableCell(withIdentifier: "AdminGroupCell", for: indexPath) as? AdminGroupCell {
                
                let groupName = groupArray[indexPath.row]
                
                cell.updateUI(groupsName: groupName)
                
                //Makes the row not clickable
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                cell.isUserInteractionEnabled = false
                
                return cell
                
            } else {
                
                return UITableViewCell()
            }
        
        } else if tableView.tag == 2 {
            
            if let cell = nameListTableView.dequeueReusableCell(withIdentifier: "AdminUsersCell", for: indexPath) as? AdminUsersCell {
                
                let userName = usersArray[indexPath.row]
                
                cell.updateUI(usersName: userName)
                
                //Makes the row not clickable for particular Users
                if cell.adminUserTypeLbl.text == "Artist" || cell.adminUserTypeLbl.text == "Buddy" {
                    
                    cell.isUserInteractionEnabled = false
                    
                }
                
                return cell
                
            } else {
                
                return UITableViewCell()
            }
            
        } else {
            
            return UITableViewCell()
            
        }
    }
    
    //Movement to a different Controller performed when selecting a row from Users TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memberName = usersArray[indexPath.row]
        performSegue(withIdentifier: "ViewMembersFromAdmin", sender: memberName)


    }

    //Prepares data to be transfered to next Controller when moving between Controllers.
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if let destination = segue.destination as? MembersCreativePieces {
            
            if let userName = sender as? Users {
                
                destination.userName  = userName
                
            }
        }
    
    if let destination = segue.destination as? EditingUserInterface {
        
        if let userName = sender as? Users {
            
            destination.userName  = userName
            
        }
    }
        
    }
    
    //Signs out user.
    
    @IBAction func backButton(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            dismiss(animated: true, completion: nil)
        
            
        } catch {
            print("Logout Error")
        }
        
    }
    
    //Performs segue to navigate to next controller.
    
    @IBAction func newUser(_ sender: Any) {
        
        performSegue(withIdentifier: "EditUsers", sender: nil)
    }
    
    
    //Allows new group to be written to Realtime Database from pop up.
    
    @IBAction func newGroup(_ sender: Any) {
        
        //Presents an alert that contains a TextField for User to enter new name of a group
        
        let alert = UIAlertController(title: "New Group", message: "Please Enter New Name For Group", preferredStyle: .alert)
        
        alert.addTextField { (groupField) in
            
            groupField.placeholder = "Please Enter Name of New Group...."

        }
        
        //Once a name has been entered it takes the text and writes that group name to the database.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
         
            let groupField = alert?.textFields![0]
            
            //Initialises reference to 'groups; branch
            
            let ref = Database.database().reference()
            let groupRef = ref.child("groups")
            let groupRefKey = groupRef.childByAutoId()
            let values = ["Group" : groupField?.text]
            
            //Updates values within 'groups' branch
            
            groupRefKey.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                
                if error == nil {
                    
                    print("Saved Succesfully into Realtime Database")
                    
                } else {
                    
                    print(error!)
                    
                }
            })
            
            //Once uploaded, now must read from the Database in order to present new Group within Tableview
            
            groupRef.observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount > 0 {
                    
                    //Must remove original array in order to present newly added Group name
                    
                    self.groupArray.removeAll()
                    
                    //Loops through all children of 'groups' extracting Group name from each and appending to array.
                    
                    for groupsNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        let groupElement = groupsNameJSON.value as? [String: AnyObject]
                        let groupElementName = groupElement!["Group"]
                        let group = Groups(groupName: groupElementName as! String)
                        
                        self.groupArray.append(group)
                        
                        
                    }
                    
                    //Reload TableView to ensure new group can be seen
                    
                    self.groupListTableView.reloadData()
                    
                }
            }
        
        }))
        
        //Adds a cancel button to the alert so user can cancel adding a group name if they wish.
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

