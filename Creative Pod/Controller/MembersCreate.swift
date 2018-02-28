//
//  MembersCreate.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//

import UIKit

class MembersCreate: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var pictureTakenImg: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var shareWithBtn: RoundedButton!
    @IBOutlet weak var pickingWhoToShareWithStack: UIStackView!
    @IBOutlet weak var shareBtn: RoundedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func chooseWhoToShareWithPressed(_ sender: Any) {
        
        pickingWhoToShareWithStack.isHidden = false
        shareBtn.isHidden = false
        
        
    }
    
    @IBAction func takingPicturePressed(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            
        }
        
        shareWithBtn.isHidden = false
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("Here I Am Lord")
        
        pictureTakenImg.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        pictureTakenImg.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    

    
    
}
