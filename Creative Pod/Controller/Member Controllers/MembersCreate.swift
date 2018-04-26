//
//  MembersCreate.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//

//Imported Libraries

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

/*
 
 @brief This class determines behaviour of the MembersCreate interface used by an Member of Artlink.
 
 */

class MembersCreate: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //Initalisation of variables and components
    
    @IBOutlet weak var pictureTakenImg: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var takingPicBtn: RoundedButton!
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
    
    //When button to take a picture is pressed then the camera opens to the user asking for their permission to use the camera.
    
    @IBAction func takingPicturePressed(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
    }
    
    //When Member is choosing who to share with stack with viable options is shown.
    
    @IBAction func choosingWhoToShareWith(_ sender: Any) {
        
        pickingWhoToShareWithStack.isHidden = false
        shareBtn.isHidden = false
        
    }
    
    //When share button is pressed, photo and who the photo has been shared with is uploaded to the cloud.
    
    @IBAction func uploadToCloudBtn(_ sender: Any) {
        
        //Checks the state of all switches whether they have been selected or not.
        
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
        
        
        
        //Initialises a random name for the taken photo and a folder for the particular user in Storage
        let imageName = NSUUID.init()
        let ref = Database.database().reference()
        let currentUserUID = Auth.auth().currentUser?.uid
        
        //Initialises reference using picture name and current users folder.
        let storageRef = Storage.storage().reference().child("\(currentUserUID!)").child("\(imageName).png")
        
        //Initialises a current user reference within 'images' branch and assigns a random string to store the photo's details.
        let imagesRef = ref.child("images")
        let usersUIDRef = imagesRef.child((currentUserUID)!)
        let imageRandomRef = usersUIDRef.childByAutoId()
        
        //Uploads the taken image to Storage fixing the orientation in the process
        if let uploadingImage = UIImagePNGRepresentation(fixOrientation(img: pictureTakenImg.image!)) {
            
            //Places photo within Storage at initialised reference.
            storageRef.putData(uploadingImage, metadata: nil, completion: { (metadata, error) in
                
                //If error is nil, extract the download URL from the metadata.
                if error == nil {
                    
                    if let imageTakenURL = metadata?.downloadURL()?.absoluteString {
                        
                        //Assign values of child node in 'images' branch in Realtime Database.
                        
                        let values = ["imageURL": imageTakenURL, "Date": metadata?.timeCreated?.description as Any, "Shared With Buddy": self.buddySwitchAnswer, "Shared With Group": self.artistSwitchAnswer, "Kept Private": self.privateSwitchAnswer ] as [String : Any]
                        
                        //Update the values within the branch.
                        
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
    
    //Removes camera if user wished to cancel taking a picture
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //When a user has decided on a photo they have taken, when they click finish the UIImageView is displayed with the taken photo.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        pictureTakenImg.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        pictureTakenImg.contentMode = .scaleAspectFill
        takingPicBtn.isHidden = true
        dismiss(animated: true, completion: nil)
        
        shareWithBtn.isHidden = false
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    /**************************************************
     * Title: Fixing Photo Orientation
     * Author: Prajna
     * Date: 2015
     * Availability: https://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload/27775741#27775741
     ***************************************************/
    
    func fixOrientation(img: UIImage) -> UIImage {
        
        //Fixes the orientation of a .png photo taken by placing within a rectangle.
        
        if (img.imageOrientation == .up) {
            return img
        }
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    
    
    
    

    
    
}
