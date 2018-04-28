//
//  MembersCreativePieces.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

/*
 
 @brief This class determines behaviour of the MembersCreativePieces.swift interface used by an all Users to view images of members.
 
 */

class MembersCreativePieces: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //Initialisation of empty variables and components to be used
    
    @IBOutlet weak var membersCollectionView: UICollectionView!
    @IBOutlet weak var membersNameLbl: UILabel!
    
    private var _groupName: Groups!
    
    var imagesOfUserUID: String = ""
    var memberNameStored: String = ""
    var groupNameStored: String = ""
    var dateStored: String = ""
    var keptPrivate: String = ""
    var sharedWithBuddy: String = ""
    var sharedWithGroup: String = ""
    var imageURL: String = ""
    var memberUID: String = ""
    var currentUserType: String = ""
    
    var viewControllerCameFrom: String = ""
    
    //Initialisation of model objects
    
    var userName: Users = Users(typeOfUser: "", userName: "", groupName: "")
    
    var storySelection: StorySelection = StorySelection(groupName: "", imageSelected: 0)

    var groupName: Groups = Groups(groupName: "")
    
    var imageArray = [Images]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Depending on what view was previously visited determines the actions that a User is able to take.
        
        if viewControllerCameFrom == "NameList" {
            
            membersNameLbl.text = userName.userName
            loadingUserImages()
            
        } else if viewControllerCameFrom == "CreationOfStoryboard" {
            
            membersNameLbl.text = storySelection.groupName
            loadingAllImages()
 
            
        } else {
            
            membersNameLbl.text = userName.userName
            loadingUserImages()
            
        }
        
        membersCollectionView.delegate = self
        membersCollectionView.dataSource = self
        
    }
    
    
    //Initialises the CollectionView and determines what will be placed within each cell. Takes advantage of CreativeProductCell to determine what does in it.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreativeProductCell", for: indexPath) as? CreativeProductCell {
            
                let imageCell = imageArray[indexPath.row]
                cell.updateUI(image: imageCell)
            
                return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
        
        
    }
    
    //Decides what occurs when a cell is pressed. It is different depending on what view controller user previously came from.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //If a Buddy they can only simply view the image as a larger piece if selected.
        if viewControllerCameFrom == "NameList" {
        
            let imageSelected = imageArray[indexPath.row]
            performSegue(withIdentifier: "ImageOfMemberViewed", sender: imageSelected)
          
        //This is for when creating a story. Depending on the previous UIImage selected from CreationOfStoryboard.swift depends what the ImageSelected object is like.
        } else if viewControllerCameFrom == "CreationOfStoryboard" {
            
            if storySelection.imageSelected == 1 {
                
                let imageSelected = imageArray[indexPath.row]
                let imageSelectedSent = ImageSelected(imageID: imageSelected.imageID, imageTag: storySelection.imageSelected, groupName: membersNameLbl.text!)
                performSegue(withIdentifier: "PictureSelected", sender: imageSelectedSent)
                
            } else if storySelection.imageSelected == 2 {
                
                let imageSelected = imageArray[indexPath.row]
                let imageSelectedSent = ImageSelected(imageID: imageSelected.imageID, imageTag: storySelection.imageSelected, groupName: membersNameLbl.text!)
                performSegue(withIdentifier: "PictureSelected", sender: imageSelectedSent)
                
            } else if storySelection.imageSelected == 3 {
                
                let imageSelected = imageArray[indexPath.row]
                let imageSelectedSent = ImageSelected(imageID: imageSelected.imageID, imageTag: storySelection.imageSelected, groupName: membersNameLbl.text!)
                performSegue(withIdentifier: "PictureSelected", sender: imageSelectedSent)
                
            }else if storySelection.imageSelected == 4 {
                
                let imageSelected = imageArray[indexPath.row]
                let imageSelectedSent = ImageSelected(imageID: imageSelected.imageID, imageTag: storySelection.imageSelected, groupName: membersNameLbl.text!)
                performSegue(withIdentifier: "PictureSelected", sender: imageSelectedSent)
                
            }

            
        } else {
            
            let imageSelected = imageArray[indexPath.row]
            performSegue(withIdentifier: "ImageOfMemberViewed", sender: imageSelected)
            
        }
        
        
    }
    
    //Prepares data to be transferred between controllers.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ImagesViewed {
            
            if let image = sender as? Images {
                
                destination.memberImage = image
                
            }
        }
        
        if let destination = segue.destination as? CreationOfStoryboard {
            
            if let imageTouched = sender as? ImageSelected {
                
                destination.destinationCameFrom = "MembersCreativePieces"
                destination.imageSelectedPassed = imageTouched
                
            }
        }

        
    }
    
    //Decides how many cells there will be depending on images taken
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
        
    }
    
    //Decides sections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Decides size of each collectionView cell.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 400, height: 450 )
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //Functions loads all the images to be viewed by for story creation by all Members of a particular group that have given the artist permission.
    
    func loadingAllImages() {
        
        //Retrieves the current user on the application type.
        let currentUserReference = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        
        currentUserReference.observeSingleEvent(of: .value) { (snapshot) in
            
            let type = snapshot.value as? [String: AnyObject]
            self.currentUserType = type!["Type"] as! String
            
        }
        
        //Creates reference to the 'users' branch and observes children for the branch.
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.imageArray.removeAll()
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    self.memberUID = membersJSON.key
                    
                    //Extracts group details from every user.
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    self.groupNameStored = memberElement?["Group"] as! String
                    
                    //If the user's group is the same as the group of the Artist creating a storyboard
                    if self.storySelection.groupName == self.groupNameStored {
                        
                        //Create a reference to the 'images' branch to those and observes those particular users images in the same group
                        let imageReference = Database.database().reference().child("images").child("\(self.memberUID)")
                        
                        imageReference.observe(DataEventType.value) { (snapshot) in
                            if snapshot.childrenCount > 0 {
                                
                                for imagesJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                    
                                    //Extract data from the users child.
                                    let imageElement = imagesJSON.value as? [String: AnyObject]
                                    self.dateStored = imageElement?["Date"] as! String
                                    self.keptPrivate = imageElement?["Kept Private"] as! String
                                    self.sharedWithBuddy = imageElement?["Shared With Buddy"] as! String
                                    self.sharedWithGroup = imageElement?["Shared With Group"] as! String
                                    self.imageURL = imageElement?["imageURL"] as! String
                                    
                                    let adjustedDateString = self.dateStored.replacingOccurrences(of: " +0000", with: "")
                                    
                                    //If access has been given to the image and depending on current user than append to the imageModel to be displayed within the collectionview.
                                    
                                    if self.sharedWithBuddy == "Access Granted" && self.currentUserType == "Buddy" {
                                        
                                        let imageModel = Images(imageID: self.imageURL, dated: adjustedDateString, memberName: self.userName.userName)
                                        self.imageArray.append(imageModel)
                                        
                                    } else if self.sharedWithGroup == "Access Granted" && self.currentUserType == "Artist" {
                                        
                                        let imageModel = Images(imageID: self.imageURL, dated: adjustedDateString, memberName: self.userName.userName)
                                        self.imageArray.append(imageModel)
                                        
                                    } else if self.keptPrivate == "Access Granted" && self.currentUserType == "Member of Artlink" {
                                        
                                        let imageModel = Images(imageID: self.imageURL, dated: adjustedDateString, memberName: self.userName.userName)
                                        self.imageArray.append(imageModel)
                                        
                                    } else if self.currentUserType == "Admin" {
                                        
                                        let imageModel = Images(imageID: self.imageURL, dated: adjustedDateString, memberName: self.userName.userName)
                                        self.imageArray.append(imageModel)
                                        
                                    }
                                    
                                }
                                
                                self.membersCollectionView.reloadData()
                                
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        
        
        
    }
    
    
    //Function to loads Members images depending on what user is trying to gain access to them.
    
    func loadingUserImages() {
        
        //Gauge current user logged into application type.
        let currentUserReference = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        
        currentUserReference.observeSingleEvent(of: .value) { (snapshot) in
            
            let type = snapshot.value as? [String: AnyObject]
            self.currentUserType = type!["Type"] as! String
            
        }
        
        //Creation of reference to 'users' branch to observe all child nodes.
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.imageArray.removeAll()
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    self.memberUID = membersJSON.key
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    self.memberNameStored = memberElement?["Name"] as! String
                    
                    //If the selected member to view their images of is the same as a child within the database.
                    if self.userName.userName == self.memberNameStored {
                        
                        
                        //Get a reference and observe their values on the 'images' branch for that chosen user.
                        let imageReference = Database.database().reference().child("images").child("\(self.memberUID)")
                        
                        imageReference.observe(DataEventType.value) { (snapshot) in
                            if snapshot.childrenCount > 0 {
                            
                                
                                //Loop through data.
                                for imagesJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                    
                                    let imageElement = imagesJSON.value as? [String: AnyObject]
                                    self.dateStored = imageElement?["Date"] as! String
                                    self.keptPrivate = imageElement?["Kept Private"] as! String
                                    self.sharedWithBuddy = imageElement?["Shared With Buddy"] as! String
                                    self.sharedWithGroup = imageElement?["Shared With Group"] as! String
                                    self.imageURL = imageElement?["imageURL"] as! String
                                    
                                    let adjustedDateString = self.dateStored.replacingOccurrences(of: " +0000", with: "")
                                    
                                    
                                    //If user trying to view the Members images have been given permission then they can view the images.
                                    if self.sharedWithBuddy == "Access Granted" && self.currentUserType == "Buddy" {
                                        
                                        let imageModel = Images(imageID: self.imageURL, dated: adjustedDateString, memberName: self.userName.userName)
                                        self.imageArray.append(imageModel)
                                        
                                    } else if self.sharedWithGroup == "Access Granted" && self.currentUserType == "Artist" {
                                        
                                        let imageModel = Images(imageID: self.imageURL, dated: adjustedDateString, memberName: self.userName.userName)
                                        self.imageArray.append(imageModel)
                                        
                                    } else if self.keptPrivate == "Access Granted" && self.currentUserType == "Member of Artlink" {
                                        
                                        let imageModel = Images(imageID: self.imageURL, dated: adjustedDateString, memberName: self.userName.userName)
                                        self.imageArray.append(imageModel)
                                        
                                    } else if self.currentUserType == "Admin" {
                                        
                                        let imageModel = Images(imageID: self.imageURL, dated: adjustedDateString, memberName: self.userName.userName)
                                        self.imageArray.append(imageModel)
                                        
                                    }
                                    
                                }
                                
                                self.membersCollectionView.reloadData()
                                
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        
    }
    
    
}
