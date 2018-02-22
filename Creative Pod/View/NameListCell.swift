//
//  NameListCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

class NameListCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(usersName: Users) {
     
        //TODO:
        
        //if memberName.typeOfUser == "Member" {
            
        userName.text = usersName.userName

        //}
        
        
        
    }

}
