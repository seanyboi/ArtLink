//
//  CreativeProductCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

/*
    @brief This subclass allows a customisation to the cells within the CollectionView of MembersCreativePieces.swift.
 
    @description Sets the image and label contained within the CollectionViewCell.
 */

class CreativeProductCell: UICollectionViewCell {
    
    @IBOutlet weak var creativeImg: UIImageView!
    @IBOutlet weak var datedLbl: UILabel!
    
    //Initiates loading spinner to be used.
    
    let activityIndicator = UIActivityIndicatorView()
    
    //Allows for image to be cached.
    
    let cachedImage = NSCache<AnyObject, AnyObject>()
    
    func updateUI(image: Images) {
        
        datedLbl.text = image.dated
        
        self.creativeImg.image = nil
        
        //Positions loading spinner in middle of cell.
        
        activityIndicator.color = .blue
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        activityIndicator.startAnimating()
        
        //Checks if the image is cached. If so simply retrieves it and sets the UIImageView.
        
        if let imageIsCached = cachedImage.object(forKey: image.imageID as AnyObject) as? UIImage {
            
            self.creativeImg.image = imageIsCached
            creativeImg.contentMode = .scaleAspectFit
            print("Cached Image")
            activityIndicator.stopAnimating()
            return
            
        }
        
        //Download of image commences using the download URL stored in Realtime Database.
        
        let imageURLConversion = URL(string: image.imageID)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                //Allows asynchronous calls so images do not download one after another.
                
                DispatchQueue.main.async {
                    
                    if let imageFromFirebase = UIImage(data: data!) {
                        
                        //Once downloaded caches the image for future usage.
                        
                        self.cachedImage.setObject(imageFromFirebase, forKey: image.imageID as AnyObject)
                        
                        //Sets UIImageView within the cell as the downloaded image.
                        
                        self.creativeImg.image = imageFromFirebase
                        
                    }
                    
                    //Once downloaded loading spinner stops
                    
                    self.activityIndicator.stopAnimating()
                }
                
            } else {
                self.activityIndicator.stopAnimating()
                return
            }
            
            
            
        }).resume()
        
        creativeImg.image = UIImage(named: "\(image.imageID)")
        creativeImg.contentMode = .scaleAspectFit
        
    }
    
    
    
    
    
}
