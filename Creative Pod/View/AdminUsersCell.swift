//
//  AdminUsersCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

class AdminUsersCell: UITableViewCell {

    @IBOutlet weak var adminUsersLbl: UILabel!
    
    @IBOutlet weak var adminUserTypeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(usersName: Users) {
        
        //TODO:
        
        //if memberName.typeOfUser == "Member" {
        
        adminUsersLbl.text = usersName.userName
        adminUserTypeLbl.text = usersName.typeOfUser
        
        //}
        
        
        
    }



}
