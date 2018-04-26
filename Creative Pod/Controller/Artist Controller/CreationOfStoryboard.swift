//
//  CreationStoryboard.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 09/03/2018.
//

//Imported Libraries

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

/*
 
    @brief This class determines behaviour of the CreationOfStoryboard interface used by an Artist
 
 */

class CreationOfStoryboard: UIViewController {
    
    private var _groupName: Groups!
    
    //Define the stacks containing UIImageViews and Captions for each image.
    
    @IBOutlet weak var image1Stack: UIStackView!
    
    @IBOutlet weak var image2Stack: UIStackView!
    
    @IBOutlet weak var image3Stack: UIStackView!
    
    @IBOutlet weak var image4Stack: UIStackView!
    
    @IBOutlet weak var saveStoryBtn: RoundedButton!
    
    @IBOutlet weak var howToCreateStoryBtn: RoundedButton!
    
    var waitingForImagesIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    //Initialisation of empty variables that values will fill.
    
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
        
        //Appends empty UIImageViews to image array
        
        self.imageArray.append(image1)
        self.imageArray.append(image2)
        self.imageArray.append(image3)
        self.imageArray.append(image4)
        
        //Loops through the image array allowing the UIImageViews to be clickable by a User by recognising tapped gestures.
        
        for image in imageArray {
            
            let tappedGesture = UITapGestureRecognizer(target: self, action: #selector(imageSelected))
            image.addGestureRecognizer(tappedGesture)
            image.isUserInteractionEnabled = true
            
        }
        
        //Determines what previous Controller was visited. Different tasks are complete depending on where User was previous.
        
        //If coming from GroupList interface, then an array is initialised to be used to create a storyboard.
        
        if destinationCameFrom == "GroupList" {
            
            self.groupNameStored = groupName.groupName
            creationOfArray()
            
            //If coming from where you select Members photos to be in the storyboard then...
            
        } else if destinationCameFrom == "MembersCreativePieces" {
            
            self.groupNameStored = imageSelectedPassed.groupName
            
            //Depending on what UIImageView is pressed, download the image and store it within the local settings file with appropriate key and update.
            
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
            
            //If coming from where you select a story to only view, then show all stacks that were previously hidden and download all images
            
        } else if destinationCameFrom == "Story Selected" {
            //to view story created
            
            self.image1Stack.isHidden = false
            self.image2Stack.isHidden = false
            self.image3Stack.isHidden = false
            self.image4Stack.isHidden = false
            self.saveStoryBtn.isHidden = true
            self.howToCreateStoryBtn.isHidden = true
            
            //User interaction disabled to ensure nothing can be changed or edited.
            
            storyTitleTxtField.isUserInteractionEnabled = false
            image1Stack.isUserInteractionEnabled = false
            image2Stack.isUserInteractionEnabled = false
            image3Stack.isUserInteractionEnabled = false
            image4Stack.isUserInteractionEnabled = false
            
            //Set components to be filled with appropriate data.
            
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
    
    //Method that creates an array that will store tags of UIImageView that have been selected.
    
    func creationOfArray() {
        
        UserDefaults.standard.set(self.arr, forKey: "arrayOfTags")
        
        UserDefaults.standard.synchronize()
        
    }
    
    
    
    // Returns an array of integers within the previous method.
    func unarchivingOfArray() -> [Int] {
        
        let arrayDataRetrieved = UserDefaults.standard.object(forKey: "arrayOfTags")
        
        let arrayData: [Int] = arrayDataRetrieved as! [Int]
        
        return arrayData
        
    }
    
    //Method that can be used to display an activity indicator to signify data is being loaded. User simply inputs 'yes' if they wish to display or 'no' to remove.
    
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
    
    
    //Method that downloads the images for viewing purposes only. This would be when an Artist wishes to view a previously created story.
    
    func downloadingImageForViewOnly(imageName: UIImageView, imageLink: String) {
        
        //Creates a reference to storage and uses the download URL of photo to find exact position.
        
        let imageStorageName = Storage.storage()
        
        let referenceOfImageToDownload = imageStorageName.reference(forURL: imageLink)
        
        //Starts downloading the image from the URL provided.
        
        referenceOfImageToDownload.downloadURL { (url, error) in
            
            if error == nil {
                
                //If error is nil then convert the download into an image that can be placed inside UIImage.
                
                let data = NSData(contentsOf: url!)! as Data
                
                let image = UIImage(data: data)
                
                //Display image downloaded.
                
                imageName.image = image
                
            } else {
                
                print(error as Any)
                return
                
            }
        }
    }
    
    //Method calling data stored using UserDefaults, how this is done by setting the tag of an image as the key within the local settings file, so you assign it like [UIImageView.tag : URL]
    
    func callingSavedImages() {
        
        //Calls method to retrieve array of stored tags
        let arr: [Int] = self.unarchivingOfArray()
        
        //Loops through array seeing what UIImageViews have been assigned photo's
        for x in 1...arr.count-1 {
            
            
            //Retrieves image for appropriate tag
            let dataContains = UserDefaults.standard.object(forKey: "\(x)") as! NSData
            
            //Loops through array of UIImageViews
            for image in imageArray {
                //If tag matches one stored within local settings file
                if image.tag == x {
                    
                    //Set the image of the UIImageView with the stored tag associated image.
                    image.image = UIImage(data: dataContains as Data)
                }
            }
        }
    }
    
    //Method that downloads image selected by User from MembersCreativePieces.swift to be placed within within storyboard.
    
    func imageDownload(urlLink: String, imageTag: Int) {
        
        //Start loading spinner.
        
        activityIndicatorAction(state: "yes")
        
        //Initiate download of photo using URL that was passed through from MembersCreativePieces.swift.
        
        let imageURLConversion = URL(string: urlLink)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            //If error is nil
            
            if error == nil {
                
                if let imageFromFirebase = UIImage(data: data!) {
                    
                    //Start asynchronous call in order to download multiple images that have been previously stored within local settings file.
                    
                    DispatchQueue.main.async {
                        
                        
                        let imageData: NSData = UIImagePNGRepresentation(imageFromFirebase)! as NSData
                        
                        //Store downloaded image within the tag of the associated UIImageView.
                        
                        UserDefaults.standard.set(imageData, forKey: "\(imageTag)")
                        
                        //Everytime calling array from local settings file.
                        var newArrayData: [Int] = self.unarchivingOfArray()
                        
                        //Check to see if the UIImageView tag is already contained within the stored array.
                        if newArrayData.contains(imageTag) {
                            
                            //Find where in array that UIImageView tag is.
                            let index = newArrayData.index(of: imageTag)
                            
                            //Overwrite position in array with imageTag
                            newArrayData[index!] = imageTag
                            
                        } else {
                            
                            //If not contained in the array append UIImageView tag to the array
                            newArrayData.append(imageTag)
                        }
                        
                        //Then display the appropriate amount of stacks containing UIImageView and caption TextField
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
                        
                        //After all this, set the array back into the same place it was held within the local settings file.
                        
                        UserDefaults.standard.set(newArrayData, forKey: "arrayOfTags")
                        
                        UserDefaults.standard.synchronize()
                        
                        //Call previously selected images to be shown within their appropriate UIImageView.
                        
                        self.callingSavedImages()
                        
                        self.activityIndicatorAction(state: "no")
                        
                    }
                }
                
            } else {
                
                print(error as Any)
                
            }
        }).resume()
    }
    
    
    //Handles when a UIImageView is selected.
    
    @objc func imageSelected(tappedGesture: UIGestureRecognizer) {
        
        //When tapped assign the UIImageView tag to variable
        if let view = tappedGesture.view as? UIImageView {
            self.imageTag = view.tag
        }
        
        //Pass this information along with group name to CreativeMembersPieces.swift
        let storySelected = StorySelection(groupName: groupNameStored, imageSelected: self.imageTag)
        
        performSegue(withIdentifier: "SelectingAnImage", sender: storySelected)
        
        
    }
    
    //Prepare data for movement between Controllers.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MembersCreativePieces {
            
            if let storySelection = sender as? StorySelection {
                
                destination.storySelection = storySelection
                destination.viewControllerCameFrom = "CreationOfStoryboard"
                
            }
        }
        
    }
    
    //Upload storyboard information into a child node of 'stories' branch.
    
    @IBAction func saveStoryBtn(_ sender: Any) {
        
        if storyTitleTxtField.text != "" {
            
            image1LinkString = UserDefaults.standard.object(forKey: "image1Link") as! String
            image2LinkString = UserDefaults.standard.object(forKey: "image2Link") as! String
            image3LinkString = UserDefaults.standard.object(forKey: "image3Link") as! String
            image4LinkString = UserDefaults.standard.object(forKey: "image4Link") as! String
            
            //Create reference to where information should be saved within Realtime Database
            
            let ref = Database.database().reference()
            
            let storyRef = ref.child("stories")
            
            let storyGroupRef = storyRef.child("\(groupNameStored)")
            
            let storyRefKey = storyGroupRef.child("\(storyTitleTxtField.text!)")
            
            //Assign values to particular keys within child node of 'stories' branch
            
            let values = ["Image 1" : image1LinkString, "Image 1 Text" : image1TxtField.text!, "Image 2" : image2LinkString, "Image 2 Text": image2TxtField.text!, "Image 3" : image3LinkString, "Image 3 Text": image3TxtField.text!, "Image 4" : image4LinkString, "Image 4 Text": image4TxtField.text!]
            
            storyRefKey.updateChildValues(values as Any as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                
                if error == nil {
                    
                    //If error is nil then wipe local settings file of all stored data so a new story can be created.
                    
                    if let appDomain = Bundle.main.bundleIdentifier {
                        UserDefaults.standard.removePersistentDomain(forName: appDomain)
                    }

                    self.performSegue(withIdentifier: "SavedChanges", sender: nil)
                    
                } else {
                    
                    
                    print(error!)
                    
                }
            })
        } else {
            
            //Display alert if error saving story.
            
            let signupAlert = UIAlertController(title: "Error", message: "There was an error saving the story, please check if there is a story title", preferredStyle: .alert)
            
            signupAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(signupAlert, animated: true, completion: nil)
            
        }
        
        
    }
    
    //Displays information on how to create a story when button is pressed within Interface.
    
    @IBAction func howToCreateStoryBtn(_ sender: Any) {
        let howToUseAlert = UIAlertController(title: "Please Read Instructions!", message: "Hello to Create A Story. Please firstly choose all four images you wish to use to create a story. Once you are finally happy on which images you will use should you then enter any details in the text boxes below the images. Otherwise the text will be erased each time you choose a new picture. Please enter a story title then click 'Save Story!'", preferredStyle: .alert)
        
        howToUseAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(howToUseAlert, animated: true, completion: nil)
        
        
    }
    
    //Returns to previous screens
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "SavedChanges", sender: nil)
        
    }
    
    
}
