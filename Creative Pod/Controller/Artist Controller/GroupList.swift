//
//  GroupList.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class GroupList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var groupArray = [Groups]()
    
    let currentUser = Auth.auth().currentUser?.uid
    var typeName: String = ""
    var name: String = ""
    var group: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child((Auth.auth().currentUser?.uid)!)
    
        print("CURRENT USER \(currentUser!)")
        
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //RETRIEVED CURRENT USERS NAME AND TYPE
            let type = snapshot.value as? [String: AnyObject]
            self.typeName = type!["Type"] as! String
            self.name = type!["Name"] as! String
            self.group = type!["Group"] as! String
            print(self.name)
            print(self.group)
            print(self.typeName)
            
            let groupNameForArtist = Groups(groupName: self.group)
            
            self.groupArray.append(groupNameForArtist)
            
            self.groupTableView.reloadData()
            
        }

        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as? GroupListCell {
            
            let groupName = groupArray[indexPath.row]
            
            cell.updateUI(groupsName: groupName)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let groupName = groupArray[indexPath.row]
        
        performSegue(withIdentifier: "ViewMembersInGroup", sender: groupName)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? NameList {
            
            if let group = sender as? Groups {
                
                destination.groupName = group
                
            }
        }
        
    }
    
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

