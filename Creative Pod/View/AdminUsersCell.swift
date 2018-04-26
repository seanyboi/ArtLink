//
//  AdminUsersCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

/*
    @brief This subclass allows a customisation to the cells within the TableView of UserGroupAdminInterface.swift.
 
    @description Sets the two labels contained within the Users TableView
 */

class AdminUsersCell: UITableViewCell {

    @IBOutlet weak var adminUsersLbl: UILabel!
    
    @IBOutlet weak var adminUserTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(usersName: Users) {
        
  
        
        adminUsersLbl.text = usersName.userName
        adminUserTypeLbl.text = usersName.typeOfUser

        
    }



}
