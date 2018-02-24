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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imagePicker.dismiss(animated: true, completion: nil)
        pictureTakenImg.image = info["UIImagePickerControllerOriginalImage"] as? UIImage
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    

    
    
}
