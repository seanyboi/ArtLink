//
//  StorySelection.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 11/03/2018.
//

import Foundation

/*
    @brief This class initiates a StorySelection object with the group name and image selected.
 
    @description Allow StorySelection objects to be past between controllers to help decide what story is selected when by an Artist to view.
 */


class StorySelection {
    
    private var _groupName: String!
    private var _imageSelected: Int!
    
    var groupName: String {
        return _groupName
    }
    
    //tag
    var imageSelected: Int {
        return _imageSelected
    }
    
    init(groupName: String, imageSelected: Int) {
        
        _groupName = groupName
        _imageSelected = imageSelected

        
    }
    
    
    
    
    
}

