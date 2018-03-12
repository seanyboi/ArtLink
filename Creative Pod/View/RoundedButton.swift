//
//  RoundedButton.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit

class RoundedButton: UIButton {

    override func awakeFromNib() {
        
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.init(red: 0, green: 157/255.0, blue: 225/255.0, alpha: 1.0).cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }

}
