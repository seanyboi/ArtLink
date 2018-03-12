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
    
   //var stories: Stories = Stories(groupName: "", image1: "", image2: "", image3: "", image4: "", image1Text: "", image2Text: "", image3Text: "", image4Text: "")
    
    var arr : [Int] = [1000000000]
    
    var imageSelectedPassed = ImageSelected(imageID: "", imageTag: 0, groupName: "")
    
    var groupName = Groups(groupName: "")
    
    var destinationCameFrom: String = ""
    
    var groupNameStored: String = ""
    
    var imageTag: Int = 0
    
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
        
        self.imageArray.append(image1)
        self.imageArray.append(image2)
        self.imageArray.append(image3)
        self.imageArray.append(image4)
        
        for image in imageArray {
            
            let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(imageSelected))
            image.addGestureRecognizer(tappedGesture)
            image.isUserInteractionEnabled = true
            
        }
  
        if destinationCameFrom == "GroupList" {
            
            self.groupNameStored = groupName.groupName
            creationOfArray()
            
        } else if destinationCameFrom == "MembersCreativePieces" {
            
            self.groupNameStored = imageSelectedPassed.groupName
            
            
            
            if imageSelectedPassed.imageTag == 1 {
            
                imageDownload(urlLink: imageSelectedPassed.imageID, imageTag: 1)
    
            } else if imageSelectedPassed.imageTag == 2 {
                
                //saved locally
               imageDownload(urlLink: imageSelectedPassed.imageID, imageTag: 2)
            
                
            } else if imageSelectedPassed.imageTag == 3 {
                
                imageDownload(urlLink: imageSelectedPassed.imageID, imageTag: 3)
        
                
            } else if imageSelectedPassed.imageTag == 4 {
                
                imageDownload(urlLink: imageSelectedPassed.imageID, imageTag: 4)
                
                
            }
        
        } else {
            
            self.groupNameStored = groupName.groupName
        }
        
        
        
    
    }
    
    func creationOfArray() {
        
        UserDefaults.standard.set(self.arr, forKey: "arrayOfTags")
        
        UserDefaults.standard.synchronize()
        
        
    }
    
    func unarchivingOfArray() -> [Int] {
        
        let arrayDataRetrieved = UserDefaults.standard.object(forKey: "arrayOfTags")
        
        return arrayDataRetrieved as! [Int]
        
    }
    
    func callingSavedImages() {
        
        print("callingSavedImages complete")
        
        let arr: [Int] = self.unarchivingOfArray()
        
        for x in 1...arr.count-1{
            
            let dataContains = UserDefaults.standard.object(forKey: "\(x)") as! NSData
            
            for image in imageArray {
            
                if image.tag == x {
                    image.image = UIImage(data: dataContains as Data)
                }
                
                
            }
        }
    
    }
    
    func imageDownload(urlLink: String, imageTag: Int) {
        
        let imageURLConversion = URL(string: urlLink)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                if let imageFromFirebase = UIImage(data: data!) {
                  
                    DispatchQueue.main.async {
                        
                        let imageData: NSData = UIImagePNGRepresentation(imageFromFirebase)! as NSData
                        
                        UserDefaults.standard.set(imageData, forKey: "\(imageTag)")
                        
                        var arrayData: [Int] = self.unarchivingOfArray()
                        
                        arrayData.append(imageTag)
                        
                        UserDefaults.standard.set(arrayData, forKey: "arrayOfTags")
                            
                        UserDefaults.standard.synchronize()
                        
                        self.callingSavedImages()

                    }
                }
        
            } else {
                
                print(error as Any)
                
            }
        }).resume()
    }
    
    
    @objc func imageSelected(tappedGesture: UIGestureRecognizer) {
        
        if let view = tappedGesture.view as? UIImageView {
            self.imageTag = view.tag
        }
        
        let storySelected = StorySelection(groupName: groupNameStored, imageSelected: self.imageTag)
        
        performSegue(withIdentifier: "SelectingAnImage", sender: storySelected)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MembersCreativePieces {
            
            if let storySelection = sender as? StorySelection {
                
                destination.storySelection = storySelection
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
        
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            
            self.dismiss(animated: true, completion: nil)

        }
        
    }
    
    
    //implement back button
    
    
    
}
