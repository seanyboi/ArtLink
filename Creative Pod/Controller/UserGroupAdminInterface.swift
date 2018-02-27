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
    
    let groupReference = Database.database().reference().child("groups")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        nameListTableView.delegate = self
        nameListTableView.dataSource = self
        
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.usersArray.removeAll()
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //TODO: May need to separate the model out into different users?
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
        
        //TODO: PLACE INSIDE FUNCTION
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
                    
                    print(self.groupArray)
                    
                }
                
                self.groupListTableView.reloadData()
                
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
        
        //TODO: Not Working
        try! Auth.auth().signOut()
        
        dismiss(animated: true, completion: nil)
        
        print("Sign out successful")
        
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
            print(values)
            print("Here I Am Lord")
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
                        
                        print(self.groupArray)
                        
                    }
                    
                    self.groupListTableView.reloadData()
                    
                }
            }
        
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //TODO: Add code for uploading to the database once inserted.
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

