//
//  AdminGroupCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import UIKit

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
