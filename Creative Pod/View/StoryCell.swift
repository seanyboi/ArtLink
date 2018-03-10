//
//  StoryCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 10/03/2018.
//

import UIKit

class StoryCell: UITableViewCell {

    @IBOutlet weak var storyNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(groupName: Groups) {
    
        storyNameLbl.text = groupName.groupName
        
        
    }


}
