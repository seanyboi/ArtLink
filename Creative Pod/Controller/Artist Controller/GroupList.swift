//
//  GroupList.swift
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
    @brief This class determines behaviour of the GroupList interface used by an Artist
 
 */

class GroupList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //Initialisation of components and variables
    
    @IBOutlet weak var groupTableView: UITableView!
    
    @IBOutlet weak var storiesTableView: UITableView!
    
    //Array of Group objects
    var groupArray = [Groups]()
    
    //Array of Stories objects
    var storiesArray = [Stories]()
    
    
    let currentUser = Auth.auth().currentUser?.uid
    
    //Initialisation of empty variables to recieve information.
    
    var typeName: String = ""
    var name: String = ""
    var group: String = ""
    var groupNameOfArtist: Groups = Groups(groupName: "")
    
    var storyTitle: String = ""
    var storyNameFromGroup: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTableView.delegate = self
        groupTableView.dataSource = self
        storiesTableView.delegate = self
        storiesTableView.dataSource = self
        
       
        receivingDataToFillTableViews()
        
        
        
    }
    
    func receivingDataToFillTableViews() {
        
        //Setting up references to access data at particular points in 'users' branch in Realtime Database.
        
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child((Auth.auth().currentUser?.uid)!)
        
        //Observation of data from pointed reference.
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //Retrieving data and placing into variables.
            
            let type = snapshot.value as? [String: AnyObject]
            self.typeName = type!["Type"] as! String
            self.name = type!["Name"] as! String
            self.group = type!["Group"] as! String
            
            let groupNameForArtist = Groups(groupName: self.group)
            
            self.groupArray.append(groupNameForArtist)
            
            self.storyNameFromGroup = groupNameForArtist.groupName
            
            //Reloading of TableView critical to ensure data is placed within.
            
            self.groupTableView.reloadData()
            
            //Setting up references to access data at particular points in 'stories' branch in Realtime Database.
            
            let storyRef = Database.database().reference().child("stories")
            let groupNameRef = storyRef.child("\(self.storyNameFromGroup)")
            
            //Observation of data from pointed reference.
            
            groupNameRef.observe(DataEventType.value) { (snapshot) in
                if snapshot.childrenCount > 0 {
                    
                    //Ensuring array is clear before appending.
                    
                    self.storiesArray.removeAll()
                    
                    for storyJSON in snapshot.children.allObjects as! [DataSnapshot] {
                        
                        self.storyTitle = storyJSON.key
                        
                        //Retrieving data and placing into variables.
                        
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
    
    
    //Initialises the data that should be inserted into the rows of the two TableViews calling methods from GroupListCell.swift and StoryCell.swift
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Due to two TableViews on one interface, each are assigned tags to distinguish between them.
        
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
    
    //Determines how many rows are placed within TableViews, in this case the length of both group and stories array.
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1 {
            return groupArray.count
        } else if tableView.tag == 2{
            return storiesArray.count
        } else {
            return 0
        }
        
        
    }
    
    //Implementation of delete button appearing when swiping on a row in Stories TableView
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if tableView.tag == 2 {
            
            //Creation of delete button
            
            let deletingStory = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                let storyOfDeletion = self.storiesArray[indexPath.row]
                
                //If Pressed remove value from the stories array that stores all previously created stories.
                
                self.storiesArray.remove(at: indexPath.row)
                self.storiesTableView.deleteRows(at: [indexPath], with: .fade)
                
                //Finds reference point of where the story chosen to be deleted is
                
                let storyReference = Database.database().reference().child("stories").child(self.storyNameFromGroup)
                
                storyReference.observe(DataEventType.value) { (snapshot) in
                    
                    if snapshot.childrenCount > 0 {
                        
                        for storiesNameJSON in snapshot.children.allObjects as! [DataSnapshot] {
                            
                            //Check to see story deleted matches a value within 'stories' branch.
                            
                            if storiesNameJSON.key == storyOfDeletion.storyName {
                                
                                //If there is a match, remove the value from the Realtime Database and display alert stating it has been deleted.
                                
                                storyReference.child(storiesNameJSON.key).removeValue()
                                
                                let deleteAlert = UIAlertController(title: "Story Deleted", message: "\(storiesNameJSON.key) Has Been Deleted", preferredStyle: .alert)
                                
                                let deleteAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                
                                deleteAlert.addAction(deleteAction)
                                
                                self.present(deleteAlert, animated: true, completion: nil)
                                
                            }
                            
                            
                        }
                        
                        //Reload of TableView essential so it does not display story just deleted.
                        
                        self.storiesTableView.reloadData()
                        
                    }
                }
            }
            
            return [deletingStory]
            
        }
        
        return [UITableViewRowAction.init()]
        
    }
    
    //Movement to a different Controller performed when selecting a row from either TableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.tag == 1 {
            
            performSegue(withIdentifier: "ViewMembersInGroup", sender: groupArray[indexPath.row])
            
        } else if tableView.tag == 2 {
            
            performSegue(withIdentifier: "CreatingNewStory", sender: storiesArray[indexPath.row])
            
        } else {
            return
        }
        
        
    }
    
    //Prepares data to be transfered to next Controller when moving between Controllers.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Checking destinations, depending what destination is associated to either TableView depends what data is transferred.
        
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
    
    //Retrieves group name of Artist to be utilised when creating a story.
    
    @IBAction func creatingNewStoryBtn(_ sender: Any) {
        
        let currentUserReference = Database.database().reference().child("users")
        let thisUserRef = currentUserReference.child((Auth.auth().currentUser?.uid)!)
        
        thisUserRef.observeSingleEvent(of: .value) { (snapshot) in
            
            //Retrieving Group name of current User from their child node of 'users' branch.
            
            let type = snapshot.value as? [String: AnyObject]
            self.group = type!["Group"] as! String
            
            self.groupNameOfArtist = Groups(groupName: self.group)
            
            self.performSegue(withIdentifier: "CreatingNewStory", sender: self.groupNameOfArtist)
            
        }
        
    }
    
    //User is signed out when log out button pressed.
    
    @IBAction func loggingOut(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            performSegue(withIdentifier: "LoggedOut", sender: nil)
        
        } catch {
            
            print("Logout Error")
            
        }
        
    }
    
}
