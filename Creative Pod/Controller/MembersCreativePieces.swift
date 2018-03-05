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

class MembersCreativePieces: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var membersCollectionView: UICollectionView!
    @IBOutlet weak var membersNameLbl: UILabel!
    
    private var _userName: Users!
    
    var imagesOfUserUID: String = ""
    var memberNameStored: String = ""
    var dateStored: String = ""
    var keptPrivate: String = ""
    var sharedWithBuddy: String = ""
    var sharedWithGroup: String = ""
    var imageURL: String = ""
    
    //TODO: Possibly send through UID too if multiple same names
    
    var userName: Users {
        get {
            return _userName
        } set {
            _userName = newValue
        }
    }
    
    var imageArray = [Images]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Check if type is member 
        membersNameLbl.text = userName.userName
        
        membersCollectionView.delegate = self
        membersCollectionView.dataSource = self
        
        let membersReference = Database.database().reference().child("users")
        
        membersReference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                
                //self.usersArray.removeAll()
                
                for membersJSON in snapshot.children.allObjects as! [DataSnapshot] {
                    
                    //TODO: May need to separate the model out into different users?
                    let memberElement = membersJSON.value as? [String: AnyObject]
                    self.memberNameStored = memberElement?["Name"] as! String
                    
                    let imageReference = Database.database().reference().child("images").child("\(membersJSON.key)")
                    
                    imageReference.observe(DataEventType.value) { (snapshot) in
                        if snapshot.childrenCount > 0 {
                            
                            for imagesJSON in snapshot.children.allObjects as! [DataSnapshot] {
                                
                                let imageElement = imagesJSON.value as? [String: AnyObject]
                                self.dateStored = imageElement?["Date"] as! String
                                self.keptPrivate = imageElement?["Kept Private"] as! String
                                self.sharedWithBuddy = imageElement?["Shared With Buddy"] as! String
                                self.sharedWithGroup = imageElement?["Shared With Group"] as! String
                                self.imageURL = imageElement?["imageURL"] as! String
                                
                                print(self.dateStored)
                                print(self.imageURL)
                                
                            }
                            
                            
                            
                        } else {
                            
                            //TODO: return empty collection view cell
                            
                        }
                    }
                }
                
                self.membersCollectionView.reloadData()
                
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreativeProductCell", for: indexPath) as? CreativeProductCell {
            
                let imageCell = imageArray[indexPath.row]
                cell.updateUI(image: imageCell)
                //print(cell)
            
                return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageSelected = imageArray[indexPath.row]
        performSegue(withIdentifier: "ImageOfMemberViewed", sender: imageSelected)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ImagesViewed {
            
            if let image = sender as? Images {
                
                destination.memberImage = image
                
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
    
}
