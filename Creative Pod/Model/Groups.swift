//
//  Groups.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import Foundation

/*
    @brief This class initiates a Group object with the Group name
 
    @description Allow Groups objects to be past between controllers and data read from database to be stored within
 */

class Groups {
    
    private var _groupName: String!
    
    var groupName: String {
        return _groupName
    }
    
    
    init(groupName: String) {
        
        _groupName = groupName
        
    }
    
    
}
