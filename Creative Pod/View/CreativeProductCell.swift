//
//  CreativeProductCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

class CreativeProductCell: UICollectionViewCell {
    
    @IBOutlet weak var creativeImg: UIImageView!
    @IBOutlet weak var datedLbl: UILabel!
    
    let activityIndicator = UIActivityIndicatorView()
    
    let cachedImage = NSCache<AnyObject, AnyObject>()
    
    func updateUI(image: Images) {
        
        datedLbl.text = image.dated
        
        self.creativeImg.image = nil
        
        activityIndicator.color = .blue
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        activityIndicator.startAnimating()
        
        if let imageIsCached = cachedImage.object(forKey: image.imageID as AnyObject) as? UIImage {
            
            self.creativeImg.image = imageIsCached
            print("Cached Image")
            activityIndicator.stopAnimating()
            return
            
        }
        
        //ACTIVITY INDICATORS CODE ADAPTED SO IT IS YOUR OWN
        
        let imageURLConversion = URL(string: image.imageID)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    
                    if let imageFromFirebase = UIImage(data: data!) {
                        
                        self.cachedImage.setObject(imageFromFirebase, forKey: image.imageID as AnyObject)
                        
                        self.creativeImg.image = imageFromFirebase
                        
                    }
                    
                    self.activityIndicator.stopAnimating()
                }
                
            } else {
                print(error as Any)
                self.activityIndicator.stopAnimating()
                return
            }
            
            
            
        }).resume()
        
        creativeImg.image = UIImage(named: "\(image.imageID)")
        creativeImg.contentMode = .scaleAspectFill
        
    }
    
    
    
    
    
}
