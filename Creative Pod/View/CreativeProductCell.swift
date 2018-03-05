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
    
    //ONLY IF IMAGE IS SAVED AS A NUMBER
    
    func updateUI(image: Images) {
        
        datedLbl.text = image.dated
        
        let imageURLConversion = URL(string: image.imageID)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                DispatchQueue.async(group: DispatchQueue.main, execute: {
                    self.creativeImg.image = UIImage(named: "\(image.imageID)")
                })
                
            } else {
                print(error)
                return
            }
            
            
            
        })
        
        creativeImg.image = UIImage(named: "\(image.imageID)")
        
    }
    
    
    
    
    
}
