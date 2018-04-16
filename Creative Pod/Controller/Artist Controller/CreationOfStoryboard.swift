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
    
    private var _groupName: Groups!
    
    @IBOutlet weak var image1Stack: UIStackView!
    
    @IBOutlet weak var image2Stack: UIStackView!
    
    @IBOutlet weak var image3Stack: UIStackView!
    
    @IBOutlet weak var image4Stack: UIStackView!
    
    @IBOutlet weak var saveStoryBtn: RoundedButton!
    
    @IBOutlet weak var howToCreateStoryBtn: RoundedButton!
    
    var waitingForImagesIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var image1LinkString: String = ""
    var image2LinkString: String = ""
    var image3LinkString: String = ""
    var image4LinkString: String = ""
    
    var arr : [Int] = [1000000000]
    
    var imageSelectedPassed = ImageSelected(imageID: "", imageTag: 0, groupName: "")
    
    var groupName = Groups(groupName: "")
    
    var storyName = Stories(storyName: "", image1: "", image2: "", image3: "", image4: "", image1Text: "", image2Text: "", image3Text: "", image4Text: "")
    
    var destinationCameFrom: String = ""
    
    var groupNameStored: String = ""
    
    var imageTag: Int = 0
    
    var image1Link: String = ""
    var image2Link: String = ""
    var image3Link: String = ""
    var image4Link: String = ""
    
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
                image1Link = imageSelectedPassed.imageID
                UserDefaults.standard.set(image1Link, forKey: "image1Link")
                UserDefaults.standard.synchronize()
                
            } else if imageSelectedPassed.imageTag == 2 {
                
                imageDownload(urlLink: imageSelectedPassed.imageID, imageTag: 2)
                image2Link = imageSelectedPassed.imageID
                UserDefaults.standard.set(image2Link, forKey: "image2Link")
                UserDefaults.standard.synchronize()
                
                
            } else if imageSelectedPassed.imageTag == 3 {
                
                imageDownload(urlLink: imageSelectedPassed.imageID, imageTag: 3)
                image3Link = imageSelectedPassed.imageID
                UserDefaults.standard.set(image3Link, forKey: "image3Link")
                UserDefaults.standard.synchronize()
                
                
            } else if imageSelectedPassed.imageTag == 4 {
                
                imageDownload(urlLink: imageSelectedPassed.imageID, imageTag: 4)
                image4Link = imageSelectedPassed.imageID
                UserDefaults.standard.set(image4Link, forKey: "image4Link")
                UserDefaults.standard.synchronize()
                
            }
            
        } else if destinationCameFrom == "Story Selected" {
            //to view story created
            
            self.image1Stack.isHidden = false
            self.image2Stack.isHidden = false
            self.image3Stack.isHidden = false
            self.image4Stack.isHidden = false
            self.saveStoryBtn.isHidden = true
            self.howToCreateStoryBtn.isHidden = true
            storyTitleTxtField.isUserInteractionEnabled = false
            image1Stack.isUserInteractionEnabled = false
            image2Stack.isUserInteractionEnabled = false
            image3Stack.isUserInteractionEnabled = false
            image4Stack.isUserInteractionEnabled = false
            
            storyTitleTxtField.text = storyName.storyName
            image1TxtField.text = storyName.image1Text
            image2TxtField.text = storyName.image2Text
            image3TxtField.text = storyName.image3Text
            image4TxtField.text = storyName.image4Text
            
            downloadingImageForViewOnly(imageName: image1, imageLink: storyName.image1)
            downloadingImageForViewOnly(imageName: image2, imageLink: storyName.image2)
            downloadingImageForViewOnly(imageName: image3, imageLink: storyName.image3)
            downloadingImageForViewOnly(imageName: image4, imageLink: storyName.image4)
            
            
        } else {
            
            self.groupNameStored = groupName.groupName
        }
        
    }
    
    func creationOfArray() {
        
        UserDefaults.standard.set(self.arr, forKey: "arrayOfTags")
        
        UserDefaults.standard.synchronize()
        
    }
    
    // returns an integer of strings
    func unarchivingOfArray() -> [Int] {
        
        let arrayDataRetrieved = UserDefaults.standard.object(forKey: "arrayOfTags")
        
        let arrayData: [Int] = arrayDataRetrieved as! [Int]
        
        return arrayData
        
    }
    
    func activityIndicatorAction(state: String) {
        
        waitingForImagesIndicator.center = self.view.center
        waitingForImagesIndicator.hidesWhenStopped = true
        waitingForImagesIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        waitingForImagesIndicator.color = .black
        
        if state == "yes" {
            
            image1Stack.isHidden = true
            view.addSubview(waitingForImagesIndicator)
            waitingForImagesIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
        } else if state == "no" {
            
            image1Stack.isHidden = false
            waitingForImagesIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
        }
        
    }
    
    
    func downloadingImageForViewOnly(imageName: UIImageView, imageLink: String) {
        
        let imageStorageName = Storage.storage()
        
        let referenceOfImageToDownload = imageStorageName.reference(forURL: imageLink)
        
        referenceOfImageToDownload.downloadURL { (url, error) in
            
            if error == nil {
                
                let data = NSData(contentsOf: url!)! as Data
                
                let image = UIImage(data: data)
                imageName.image = image
                
            } else {
                
                print(error as Any)
                return
                
            }
        }
    }
    
    // calling data stored using core data, how this is done by setting the tag of an image as the key within the database, so you assign it like [1: url], [2: url]
    //sets the images in imageViews.
    
    func callingSavedImages() {
        let arr: [Int] = self.unarchivingOfArray()
        for x in 1...arr.count-1 {
            let dataContains = UserDefaults.standard.object(forKey: "\(x)") as! NSData
            for image in imageArray {
                if image.tag == x {
                    image.image = UIImage(data: dataContains as Data)
                }
            }
        }
    }
    
    func imageDownload(urlLink: String, imageTag: Int) {
        
        activityIndicatorAction(state: "yes")
        
        let imageURLConversion = URL(string: urlLink)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                if let imageFromFirebase = UIImage(data: data!) {
                    
                    DispatchQueue.main.async {
                        
                        let imageData: NSData = UIImagePNGRepresentation(imageFromFirebase)! as NSData
                        UserDefaults.standard.set(imageData, forKey: "\(imageTag)")
                        
                        //everytime calling array from core data
                        var newArrayData: [Int] = self.unarchivingOfArray()
                        
                        //if stored array contains the imageTag. This is for if the imagetag is already contained within array
                        if newArrayData.contains(imageTag) {
                            
                            //find where in array that imageTag is
                            let index = newArrayData.index(of: imageTag)
                            
                            //overwrite position in array with imageTag
                            newArrayData[index!] = imageTag
                            
                        } else {
                            
                            // if not contained in the array append imagetag to the array
                            newArrayData.append(imageTag)
                        }
                        
                        //then display the appropriate amount of imagestacks
                        if newArrayData.count == 2 {
                            self.image2Stack.isHidden = false
                        } else if newArrayData.count == 3 {
                            self.image2Stack.isHidden = false
                            self.image3Stack.isHidden = false
                        } else if newArrayData.count == 4 {
                            self.image2Stack.isHidden = false
                            self.image3Stack.isHidden = false
                            self.image4Stack.isHidden = false
                        } else if newArrayData.count == 5 {
                            self.image2Stack.isHidden = false
                            self.image3Stack.isHidden = false
                            self.image4Stack.isHidden = false
                            self.saveStoryBtn.isHidden = false
                            
                        }
                        
                        //after all this, set the array back into the same place it was held within the core data.
                        UserDefaults.standard.set(newArrayData, forKey: "arrayOfTags")
                        
                        UserDefaults.standard.synchronize()
                        
                        self.callingSavedImages()
                        
                        self.activityIndicatorAction(state: "no")
                        
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
            
            image1LinkString = UserDefaults.standard.object(forKey: "image1Link") as! String
            image2LinkString = UserDefaults.standard.object(forKey: "image2Link") as! String
            image3LinkString = UserDefaults.standard.object(forKey: "image3Link") as! String
            image4LinkString = UserDefaults.standard.object(forKey: "image4Link") as! String
            
            
            let ref = Database.database().reference()
            
            let storyRef = ref.child("stories")
            
            let storyGroupRef = storyRef.child("\(groupNameStored)")
            
            let storyRefKey = storyGroupRef.child("\(storyTitleTxtField.text!)")
            
            let values = ["Image 1" : image1LinkString, "Image 1 Text" : image1TxtField.text!, "Image 2" : image2LinkString, "Image 2 Text": image2TxtField.text!, "Image 3" : image3LinkString, "Image 3 Text": image3TxtField.text!, "Image 4" : image4LinkString, "Image 4 Text": image4TxtField.text!]
            
            storyRefKey.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                
                if error == nil {
                    
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }
                    print("Saved Succesfully into Realtime Database")
                    self.performSegue(withIdentifier: "SavedChanges", sender: nil)
                    
                } else {
                    
                    
                    print(error!)
                    
                }
            })
        } else {
            
            let signupAlert = UIAlertController(title: "Error", message: "There was an error saving the story, please check if there is a story title", preferredStyle: .alert)
            
            signupAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(signupAlert, animated: true, completion: nil)
            
        }
        
        
    }
    
    
    @IBAction func howToCreateStoryBtn(_ sender: Any) {
        let howToUseAlert = UIAlertController(title: "Please Read Instructions!", message: "Hello to Create A Story. Please firstly choose all four images you wish to use to create a story. Once you are finally happy on which images you will use should you then enter any details in the text boxes below the images. Otherwise the text will be erased each time you choose a new picture. Please enter a story title then click 'Save Story!'", preferredStyle: .alert)
        
        howToUseAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(howToUseAlert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "SavedChanges", sender: nil)
        
    }
    
    
}
    
    
    //implement back button

