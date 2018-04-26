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
    
    @IBOutlet weak var storiesTableView: UITableView!
    
    var groupArray = [Groups]()
    var storiesArray = [Stories]()
    
    let currentUser = Auth.auth().currentUser?.uid
    var typeName: String = ""
    var name: String = ""
    var group: String = ""
    var groupNameOfArtist: Groups = Groups(groupName: "")
    
    var storyTitle: String = ""
    var storyNameFromGroup: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child((Auth.auth().currentUser?.uid)!)
        
        groupTableView.delegate = self
        groupTableView.dataSource = self
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //RETRIEVED CURRENT USERS NAME AND TYPE
            let type = snapshot.value as? [String: AnyObject]
            self.typeName = type!["Type"] as! String
            self.name = type!["Name"] as! String
            self.group = type!["Group"] as! String
            
            let groupNameForArtist = Groups(groupName: self.group)
            
            self.groupArray.append(groupNameForArtist)
            
            self.storyNameFromGroup = groupNameForArtist.groupName
            
            self.groupTableView.reloadData()
            
            let storyRef = Database.database().reference().child("stories")
            let groupNameRef = storyRef.child("\(self.storyNameFromGroup)")
            
            groupNameRef.observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount > 0 {
                    
                    self.storiesArray.removeAll()
                    
                    for storyJSON in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        self.storyTitle = storyJSON.key
                        
                        let storyElement = storyJSON.value as? [String: AnyObject]
                        let image1 = storyElement?["Image 1"] as! String
                        let image1Text = storyElement?["Image 1 Text"] as! String
                        let image2 = storyElement?["Image 2"] as! String
                        let image2Text = storyElement?["Image 2 Text"] as! String
                        let image3 = storyElement?["Image 3"] as! String
                        let image3Text = storyElement?["Image 3 Text"] as! String
                        let image4 = storyElement?["Image 4"] as! String
                        let image4Text = storyElement?["Image 4 Text"] as! String
                        
                        let storyName = Stories(storyName: self.storyTitle, image1: image1, image2: image2, image3: image3, image4: image4, image1Text: image1Text, image2Text: image2Text, image3Text: image3Text, image4Text: image4Text)
                        
                        self.storiesArray.append(storyName)
                        
                        self.storiesTableView.reloadData()
                        
                    }
                    
                }
            }
            
            
        }
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1 {
            if let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as? GroupListCell {
                
                let groupName = groupArray[indexPath.row]
                
                cell.updateUI(groupsName: groupName)
                
                return cell
                
            } else {
                
                return UITableViewCell()
            }
        } else if tableView.tag == 2 {
            
            if let cell = storiesTableView.dequeueReusableCell(withIdentifier: "StoryCell", for: indexPath) as? StoryCell {
                
                let storyName = storiesArray[indexPath.row]
                cell.updateUI(storyName: storyName)
                
                return cell
                
            } else {
                return UITableViewCell()
            }
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return groupArray.count
        } else if tableView.tag == 2{
            return storiesArray.count
        } else {
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if tableView.tag == 2 {
            
            let deletingStory = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                let storyOfDeletion = self.storiesArray[indexPath.row]
                
                self.storiesArray.remove(at: indexPath.row)
                self.storiesTableView.deleteRows(at: [indexPath], with: .fade)
                
                let storyReference = Database.database().reference().child("stories").child(self.storyNameFromGroup)
                
                storyReference.observe(DataEventType.value) { (snapshot) in
                    
                    if snapshot.childrenCount > 0 {
                        
                        for storiesNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                            
                            //TODO: IF TIME REMOVE ALL GROUP FROM PEOPLE
                            if storiesNameJSON.key == storyOfDeletion.storyName {
                                
                                storyReference.child(storiesNameJSON.key).removeValue()
                                
                                let deleteAlert = UIAlertController(title: "Story Deleted", message: "\(storiesNameJSON.key) Has Been Deleted", preferredStyle: .alert)
                                
                                let deleteAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                
                                deleteAlert.addAction(deleteAction)
                                
                                self.present(deleteAlert, animated: true, completion: nil)
                                
                            }
                            
                            
                        }
                        
                        self.storiesTableView.reloadData()
                        
                    }
                }
            }
            
            return [deletingStory]
            
        }
        
        return [UITableViewRowAction.init()]
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            
            performSegue(withIdentifier: "ViewMembersInGroup", sender: groupArray[indexPath.row])
            
        } else if tableView.tag == 2 {
            
            performSegue(withIdentifier: "CreatingNewStory", sender: storiesArray[indexPath.row])
            
        } else {
            return
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? NameList {
            
            if let group = sender as? Groups {
                
                destination.groupName = group
                
            }
        }
        
        if let destination = segue.destination as? CreationOfStoryboard {
            
            if let groupName = sender as? Groups {
                
                destination.destinationCameFrom = "GroupList"
                destination.groupName = groupName
                
            } else if let storyName = sender as? Stories {
                
                destination.destinationCameFrom = "Story Selected"
                destination.storyName = storyName
                
            }
        }
        
    }
    
    @IBAction func creatingNewStoryBtn(_ sender: Any) {
        
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child((Auth.auth().currentUser?.uid)!)
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //RETRIEVED CURRENT USERS NAME AND TYPE
            
            let type = snapshot.value as? [String: AnyObject]
            self.group = type!["Group"] as! String
            
            self.groupNameOfArtist = Groups(groupName: self.group)
            
            self.performSegue(withIdentifier: "CreatingNewStory", sender: self.groupNameOfArtist)
            
        }
        
    }
    
    @IBAction func loggingOut(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            performSegue(withIdentifier: "LoggedOut", sender: nil)
            
            print("Sign out successful")
            
        } catch {
            
            print("Logout Error")
        }
        
    }
    
}
