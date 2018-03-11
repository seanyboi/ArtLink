//
//  ImagesViewed.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 24/02/2018.
//

import UIKit

class ImagesViewed: UIViewController {
    
    
    @IBOutlet weak var imageOfMember: UIImageView!
    
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
        
        let imageURLConversion = URL(string: memberImage.imageID)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    self.imageOfMember.image = UIImage(data: data!)
                }
                
            } else {
                print(error as Any)
                return
            }
            
            
            
        }).resume()
        
        
        
        
        
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}
