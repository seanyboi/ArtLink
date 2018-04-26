//
//  StoryCell.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 10/03/2018.
//

import UIKit

/*
    @brief This subclass allows a customisation to the cells within the TableView of GroupList.swift.
 
    @description Sets the label contained within the Stories TableView.
 */

class StoryCell: UITableViewCell {

    @IBOutlet weak var storyNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(storyName: Stories) {
    
        storyNameLbl.text = storyName.storyName
        
        
    }


}
