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
        
        print(image.dated)
        print(image.imageID)
        print("Member is: \(image.memberName)")
        
        datedLbl.text = image.dated
        creativeImg.image = UIImage(named: "\(image.imageID)")
        
    }
    
    
    
    
    
}
