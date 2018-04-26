//
//  AdminGroupCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

/*
    @brief This subclass allows a customisation to the cells within the TableView of UserGroupAdminInterface.swift.
 
    @description Sets the label contained within the Groups TableView.
 */

class AdminGroupCell: UITableViewCell {

    @IBOutlet weak var adminGroupLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateUI(groupsName: Groups) {
        

        
        adminGroupLbl.text = groupsName.groupName
        

        
        
        
    }



}
