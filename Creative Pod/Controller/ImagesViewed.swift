//
//  ImagesViewed.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 24/02/2018.
//

import UIKit

class ImagesViewed: UIViewController {
    
    
    @IBOutlet weak var imageOfMember: UIImageView!
    
    @IBOutlet weak var editUserBtn: UIButton!
    
    
    private var _image: Images!
    
    var memberImage: Images {
        get {
            return _image
        } set {
            _image = newValue
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageOfMember.image = UIImage(named: "\(memberImage.imageID)")
        
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}
