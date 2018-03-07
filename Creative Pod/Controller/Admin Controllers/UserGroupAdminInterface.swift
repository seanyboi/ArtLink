//
//  UserGroupAdminInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//


import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth

class UserGroupAdminInterface: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var groupListTableView: UITableView!
    
    @IBOutlet weak var nameListTableView: UITableView!
    
    var usersArray = [Users]()
    var groupArray = [Groups]()
    
    var memberUID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        nameListTableView.delegate = self
        nameListTableView.dataSource = self
        
        pullUserData()
        pullGroupData()
    
    }
    
    func pullUserData() {
        
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.usersArray.removeAll()
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    let typeName = memberElement?["Type"]
                    let userName = memberElement?["Name"]
                    let groupName = memberElement?["Group"]
                    
                    let member = Users(typeOfUser: typeName as! String?, userName: userName as! String?, groupName: groupName as! String?)
                    
                    self.usersArray.append(member)
                    
                }
                
                self.nameListTableView.reloadData()
                
            }
        }
    }
    
    func pullGroupData() {
        
        let groupReference = Database.database().reference().child("groups")
        
        groupReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.groupArray.removeAll()
                
                for groupsNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    let groupElement = groupsNameJSON.value as? [String: AnyObject]
                    let groupElementName = groupElement!["Group"]
                    let group = Groups(groupName: groupElementName as! String)
                    
                    self.groupArray.append(group)
                    
                }
                
                self.groupListTableView.reloadData()
                
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if tableView.tag == 1 {
                
                let groupOfDeletion = self.groupArray[indexPath.row]
                self.groupArray.remove(at: indexPath.row)
                groupListTableView.deleteRows(at: [indexPath], with: .fade)
                
            } else if tableView.tag == 2 {
                
                let nameOfDeletion = self.usersArray[indexPath.row]
                self.usersArray.remove(at: indexPath.row)
                nameListTableView.deleteRows(at: [indexPath], with: .fade)
                
                let membersReference = Database.database().reference().child("users")
                
                membersReference.observe(DataEventType.value) { (snapshot) in
                    if snapshot.childrenCount > 0 {
                        
                        for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                            
                            self.memberUID = membersJSON.key
                            
                            let memberElement = membersJSON.value as? [String: AnyObject]
                            let userName = memberElement?["Name"] as! String
                            
                            if nameOfDeletion.userName == userName {
                                
                                if Auth.auth().currentUser?.uid == self.memberUID {
                                
                                    let deleteAlert = UIAlertController(title: "Error", message: "Cannot Remove Your Own User", preferredStyle: .alert)
                                    
                                    let deleteAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    
                                    deleteAlert.addAction(deleteAction)
                                    
                                    self.present(deleteAlert, animated: true, completion: nil)
                                    
                                    
                                } else {
                                    
                                    membersReference.child(self.memberUID).removeValue()
                                    
                                }
                            
                            }

                        }
                        
                    }
                }
                
            }

        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            
            return groupArray.count
            
        } else if tableView.tag == 2 {
            
            return usersArray.count
            
        } else {
            
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        if tableView.tag == 1 {
        
            if let cell = groupListTableView.dequeueReusableCell(withIdentifier: "AdminGroupCell", for: indexPath) as? AdminGroupCell {
                
                let groupName = groupArray[indexPath.row]
                
                cell.updateUI(groupsName: groupName)
                
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memberName = usersArray[indexPath.row]
        performSegue(withIdentifier: "ViewMembersFromAdmin", sender: memberName)


    }

    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       if let destination = segue.destination as? MembersCreativePieces {
            
            if let user = sender as? Users {
                
                destination.userName  = user
                
            }
        }
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            dismiss(animated: true, completion: nil)
            
            print("Sign out successful")
            
        } catch {
            print("Logout Error")
        }
        
    }
    
    @IBAction func newUser(_ sender: Any) {
        
        performSegue(withIdentifier: "EditUsers", sender: nil)
    }
    
    
    @IBAction func newGroup(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Group", message: "Please Enter New Name For Group", preferredStyle: .alert)
        
        alert.addTextField { (groupField) in
            
            groupField.placeholder = "Please Enter Name of New Group...."

        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
         
            let groupField = alert?.textFields![0]
            
            let ref = Database.database().reference()
            let groupRef = ref.child("groups")
            let groupRefKey = groupRef.childByAutoId()
            let values = ["Group" : groupField?.text]
            groupRefKey.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                
                if error == nil {
                    
                    print("Saved Succesfully into Realtime Database")
                    
                } else {
                    
                    print(error!)
                    
                }
            })
            
            let groupReference = Database.database().reference().child("groups")
            
            groupReference.observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount > 0 {
                    
                    self.groupArray.removeAll()
                    
                    for groupsNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        //TODO: May need to separate the model out into different users?
                        let groupElement = groupsNameJSON.value as? [String: AnyObject]
                        let groupElementName = groupElement!["Group"]
                        let group = Groups(groupName: groupElementName as! String)
                        
                        self.groupArray.append(group)
                        
                        
                    }
                    
                    self.groupListTableView.reloadData()
                    
                }
            }
        
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

