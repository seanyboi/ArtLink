//
//  GroupListCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

/*
    @brief This subclass allows a customisation to the cells within the TableView of GroupList.swift
 
    @description Sets the label contained within the TableView
 */

class GroupListCell: UITableViewCell {
    
    
    @IBOutlet weak var groupNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(groupsName: Groups) {
        
        
        groupNameLbl.text = groupsName.groupName
        
    }

    
    
}
