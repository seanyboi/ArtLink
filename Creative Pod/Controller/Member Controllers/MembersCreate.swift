//
//  MembersCreate.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class MembersCreate: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var pictureTakenImg: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var shareWithBtn: RoundedButton!
    @IBOutlet weak var pickingWhoToShareWithStack: UIStackView!
    @IBOutlet weak var shareBtn: RoundedButton!
    
    @IBOutlet weak var buddySwitch: UISwitch!
    @IBOutlet weak var artistSwitch: UISwitch!
    @IBOutlet weak var privateSwitch: UISwitch!
    
    @IBOutlet weak var buddyLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var privateLbl: UILabel!
    
    let isOnTrue: String = "Access Granted"
    let isOnFalse: String = "Access Denied"
    
    var buddySwitchAnswer: String = ""
    var artistSwitchAnswer: String = ""
    var privateSwitchAnswer: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func takingPicturePressed(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    
    @IBAction func choosingWhoToShareWith(_ sender: Any) {
        
        pickingWhoToShareWithStack.isHidden = false
        shareBtn.isHidden = false
        
    }
    
    @IBAction func uploadToCloudBtn(_ sender: Any) {
        
        if buddySwitch.isOn {
            
            buddySwitchAnswer = isOnTrue
            
        } else {
            buddySwitchAnswer = isOnFalse
        }
        
        if artistSwitch.isOn {
            
                artistSwitchAnswer = isOnTrue
            
        } else {
            artistSwitchAnswer = isOnFalse
        }
        
        if privateSwitch.isOn {
            
            privateSwitchAnswer = isOnTrue
            
        } else {
            privateSwitchAnswer = isOnFalse
        }
        
        //Storage
        let imageName = NSUUID.init()
        let ref = Database.database().reference()
        let currentUserUID = Auth.auth().currentUser?.uid
        //Possibly have folder named after the users
        let storageRef = Storage.storage().reference().child("\(currentUserUID!)").child("\(imageName).png")
        
        //Database
        let imagesRef = ref.child("images")
        let usersUIDRef = imagesRef.child((currentUserUID)!)
        let imageRandomRef = usersUIDRef.childByAutoId()
        
        //Storage Upload
        if let uploadingImage = UIImagePNGRepresentation(pictureTakenImg.image!) {
            
            storageRef.putData(uploadingImage, metadata: nil, completion: { (metadata, error) in
                
                if error == nil {
                    
                    if let imageTakenURL = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["imageURL": imageTakenURL, "Date": metadata?.timeCreated?.description as Any, "Shared With Buddy": self.buddySwitchAnswer, "Shared With Group": self.artistSwitchAnswer, "Kept Private": self.privateSwitchAnswer ] as [String : Any]
                        
                        imageRandomRef.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                            
                            if error == nil {
                                
                                print("Saved Succesfully into Realtime Database")
                                
                            } else {
                                
                                print(error!)
                                
                            }
                            
                            
                        })
                        
                        
                    }
        
                }
                
            })
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        pictureTakenImg.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        pictureTakenImg.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
        
        shareWithBtn.isHidden = false
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    

    
    
}
