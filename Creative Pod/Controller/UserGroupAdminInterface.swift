//
//  UserGroupAdminInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//


import UIKit

class UserGroupAdminInterface: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var groupListTableView: UITableView!
    
    @IBOutlet weak var nameListTableView: UITableView!
    
    var usersArray = [Users]()
    var groupArray = [Groups]()    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupListTableView.delegate = self
        groupListTableView.dataSource = self
        nameListTableView.delegate = self
        nameListTableView.dataSource = self
        
        
        let memberTest1 = Users(typeOfUser: "Member", userName: "John Adams", groupName: "Art World")
        let memberTest2 = Users(typeOfUser: "Member", userName: "Paul Smith", groupName: "Reach Out")
        let memberTest3 = Users(typeOfUser: "Artist", userName: "Adam Armani", groupName: "Reach Out")
        let groupTest1 = Groups(groupName: "Art World")
        let groupTest2 = Groups(groupName: "Reach Out")
        
        usersArray.append(memberTest1)
        usersArray.append(memberTest2)
        usersArray.append(memberTest3)
        groupArray.append(groupTest1)
        groupArray.append(groupTest2)
        
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
        
        dismiss(animated: true, completion: nil)
        
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
            self.groupArray.append(Groups(groupName: (groupField?.text)!))
            self.groupListTableView.reloadData()

        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //TODO: Add code for uploading to the database once inserted.
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
}

