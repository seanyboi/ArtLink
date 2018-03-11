//
//  CreationStoryboard.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 09/03/2018.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class CreationOfStoryboard: UIViewController {
    
    
    //TODO: Getter, Setter for the for the group name
    
    private var _groupName: Groups!
    
    var groupName: Groups {
        get {
            return _groupName
        } set {
            _groupName = newValue
        }
    }
    
    var groupNameStored: String = ""
    
    var imageArray: [UIImageView] = [UIImageView]()
    
    @IBOutlet weak var storyTitleTxtField: UITextField!
    
    @IBOutlet weak var image1: UIImageView!
    
    var image1URL: String = ""
    
    @IBOutlet weak var image2: UIImageView!
    
    var image2URL: String = ""
    
    @IBOutlet weak var image3: UIImageView!
    
    var image3URL: String = ""
    
    @IBOutlet weak var image4: UIImageView!
    
    var image4URL: String = ""
    
    @IBOutlet weak var image1TxtField: UITextView!
    
    @IBOutlet weak var image2TxtField: UITextView!
    
    @IBOutlet weak var image3TxtField: UITextView!
    
    @IBOutlet weak var image4TxtField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        self.groupNameStored = groupName.groupName
        
        print(groupNameStored)
        
        self.imageArray.append(image1)
        self.imageArray.append(image2)
        self.imageArray.append(image3)
        self.imageArray.append(image4)
        
        for image in imageArray {
            
            let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(imageSelected))
            image.addGestureRecognizer(tappedGesture)
            image.isUserInteractionEnabled = true
            
            
            
        }
    
    
    }
    
    
    @objc func imageSelected() {
        
        let groupName = Groups(groupName: groupNameStored)
        performSegue(withIdentifier: "SelectingAnImage", sender: groupName)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MembersCreativePieces {
            
            if let groupName = sender as? Groups {
                
                destination.groupName = groupName
                destination.viewControllerCameFrom = "CreationOfStoryboard"
                
            }
        }
        
    }
    
    @IBAction func saveStoryBtn(_ sender: Any) {
        
        if storyTitleTxtField.text != "" {
        
            let ref = Database.database().reference()
            
            let storyRef = ref.child("stories")
            
            let storyGroupRef = storyRef.child("\(groupNameStored)")
        
            let storyRefKey = storyGroupRef.child("\(storyTitleTxtField.text!)")
            
            let values = ["Image 1" : self.image1URL, "Image 1 Text" : image1TxtField.text!, "Image 2" : self.image2URL, "Image 2 Text": image2TxtField.text!, "Image 3" : self.image3URL, "Image 3 Text": image3TxtField.text!, "Image 4" : self.image4URL, "Image 4 Text": image4TxtField.text!]
            
            storyRefKey.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                
                if error == nil {
                    
                    print("Saved Succesfully into Realtime Database")
                    
                } else {
                    
                    
                    print(error!)
                    
                }
            })
        } else {
                
                let signupAlert = UIAlertController(title: "Error", message: "There was an error saving the story, please check if there is a story title", preferredStyle: .alert)
                
                self.present(signupAlert, animated: true, completion: nil)

            }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            
            self.dismiss(animated: true, completion: nil)

        }
        
    }
    
    
    //implement back button
    
    
    
}
