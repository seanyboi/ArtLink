//
//  Members.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import Foundation


class Users {
    
    
    private var _userName: String!
    private var _typeOfUser: String!
    private var _groupName: String!
    
    
    var userName: String {
        return _userName
    }
    
    var typeOfUser: String {
        return _typeOfUser
    }
    
    var groupName: String {
        return _groupName
    }
    
    init(typeOfUser: String, userName: String, groupName: String) {
        
        _userName = userName
        _typeOfUser = typeOfUser
        _groupName = groupName
        
    }
    
    
}
