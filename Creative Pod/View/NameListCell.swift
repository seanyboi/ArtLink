//
//  NameListCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

/*
    @brief This subclass allows a customisation to the cells within the TableView of NameList.swift.
 
    @description Sets the label contained within the TableView
 */

class NameListCell: UITableViewCell {
    
    
    @IBOutlet weak var memberName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(usersName: Users) {
     
        
        memberName.text = usersName.userName

    }

}
