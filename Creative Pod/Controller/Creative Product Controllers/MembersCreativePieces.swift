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

class MembersCreativePieces: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var membersCollectionView: UICollectionView!
    @IBOutlet weak var membersNameLbl: UILabel!
    
    //private var _userName: Users!
    
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
    
    var userName: Users = Users(typeOfUser: "", userName: "", groupName: "")
    
//    var userName: Users {
//        get {
//            return _userName
//        } set {
//            _userName = newValue
//        }
//    }
    
    var groupName: Groups {
        get {
            return _groupName
        } set {
            _groupName = newValue
        }
    }
    
    var imageArray = [Images]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DETERMINE WHAT SCREEN WAS PREVIOUS
        
        if viewControllerCameFrom == "NameList" {
            
            membersNameLbl.text = userName.userName
            loadingUserImages()
            
        } else if viewControllerCameFrom == "CreationOfStoryboard" {
            
            membersNameLbl.text = groupName.groupName
            loadingAllImages()
            
        } else {
            
            membersNameLbl.text = userName.userName
            loadingUserImages()
            
        }
        
        membersCollectionView.delegate = self
        membersCollectionView.dataSource = self
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreativeProductCell", for: indexPath) as? CreativeProductCell {
            
                let imageCell = imageArray[indexPath.row]
                cell.updateUI(image: imageCell)
            
                return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if viewControllerCameFrom == "NameList" {
        
            let imageSelected = imageArray[indexPath.row]
            performSegue(withIdentifier: "ImageOfMemberViewed", sender: imageSelected)
            
        } else if viewControllerCameFrom == "CreationOfStoryboard" {
            
            let groupIdentifier = Groups(groupName: membersNameLbl.text!)
            performSegue(withIdentifier: "PictureSelected", sender: groupIdentifier)
            
        } else {
            
            let imageSelected = imageArray[indexPath.row]
            performSegue(withIdentifier: "ImageOfMemberViewed", sender: imageSelected)
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ImagesViewed {
            
            if let image = sender as? Images {
                
                destination.memberImage = image
                
            }
        }
        
        if let destination = segue.destination as? CreationOfStoryboard {
            
            if let groupName = sender as? Groups {
                
                destination.groupName = groupName
                
            }
        }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 330, height: 330 )
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func loadingAllImages() {
        
        let currentUserReference = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        
        currentUserReference.observeSingleEvent(of: .value) { (snapshot) in
            
            //RETRIEVED CURRENT TYPE
            let type = snapshot.value as? [String: AnyObject]
            self.currentUserType = type!["Type"] as! String
            
        }
        
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.imageArray.removeAll()
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    self.memberUID = membersJSON.key
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    self.groupNameStored = memberElement?["Group"] as! String
                    
                    if self.groupName.groupName == self.groupNameStored {
                        
                        let imageReference = Database.database().reference().child("images").child("\(self.memberUID)")
                        
                        imageReference.observe(DataEventType.value) { (snapshot) in
                            if snapshot.childrenCount > 0 {
                                
                                
                                for imagesJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                    
                                    let imageElement = imagesJSON.value as? [String: AnyObject]
                                    self.dateStored = imageElement?["Date"] as! String
                                    self.keptPrivate = imageElement?["Kept Private"] as! String
                                    self.sharedWithBuddy = imageElement?["Shared With Buddy"] as! String
                                    self.sharedWithGroup = imageElement?["Shared With Group"] as! String
                                    self.imageURL = imageElement?["imageURL"] as! String
                                    
                                    let adjustedDateString = self.dateStored.replacingOccurrences(of: " +0000", with: "")
                                    
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
    
    
    func loadingUserImages() {
        
        let currentUserReference = Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!)
        
        currentUserReference.observeSingleEvent(of: .value) { (snapshot) in
            
            //RETRIEVED CURRENT TYPE
            let type = snapshot.value as? [String: AnyObject]
            self.currentUserType = type!["Type"] as! String
            
        }
        
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                self.imageArray.removeAll()
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    self.memberUID = membersJSON.key
                    
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    self.memberNameStored = memberElement?["Name"] as! String
                    
                    if self.userName.userName == self.memberNameStored {
                        
                        let imageReference = Database.database().reference().child("images").child("\(self.memberUID)")
                        
                        imageReference.observe(DataEventType.value) { (snapshot) in
                            if snapshot.childrenCount > 0 {
                                
                                
                                for imagesJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                    
                                    let imageElement = imagesJSON.value as? [String: AnyObject]
                                    self.dateStored = imageElement?["Date"] as! String
                                    self.keptPrivate = imageElement?["Kept Private"] as! String
                                    self.sharedWithBuddy = imageElement?["Shared With Buddy"] as! String
                                    self.sharedWithGroup = imageElement?["Shared With Group"] as! String
                                    self.imageURL = imageElement?["imageURL"] as! String
                                    
                                    let adjustedDateString = self.dateStored.replacingOccurrences(of: " +0000", with: "")
                                    
                                    
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
