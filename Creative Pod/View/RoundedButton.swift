//
//  RoundedButton.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit

/*
    @brief This subclass allows a custom border to be created around a button.
 
    @description Sets the border width for the button, what colour the button should be, and if there should be a curve at the border.
 */

class RoundedButton: UIButton {

    override func awakeFromNib() {
        
        self.layer.borderWidth = 1.5
        self.layer.borderColor = UIColor.init(red: 0, green: 157/255.0, blue: 225/255.0, alpha: 1.0).cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }

}
