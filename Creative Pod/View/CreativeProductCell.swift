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
    
    func updateUI(image: Images) {
        
        datedLbl.text = image.dated
        
        let imageURLConversion = URL(string: image.imageID)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    
                    let downloadedImage = UIImage(data: data!)
                    
                    UIGraphicsBeginImageContextWithOptions((downloadedImage?.size)!, false, (downloadedImage?.scale)!)
                    let rectangle = CGRect(x: 0, y: 0, width: (downloadedImage?.size.width)!, height: (downloadedImage?.size.height)!)
                    downloadedImage?.draw(in: rectangle)
                    
                    let orientatedImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    self.creativeImg.image = orientatedImage
                }
                
            } else {
                print(error as Any)
                return
            }
            
            
            
        }).resume()
        
        creativeImg.image = UIImage(named: "\(image.imageID)")
        creativeImg.contentMode = .scaleAspectFill
        
    }
    
    
    
    
    
}
