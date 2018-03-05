//
//  Images.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 22/02/2018.
//

import Foundation

class Images {
    
    private var _imageID: String!
    private var _dated: String!
    private var _memberName: String!
    
    var imageID: String {
        return _imageID
    }
    
    var dated: String {
        return _dated
    }
    
    var memberName: String {
        return _memberName
    }
    
    
    init(imageID: String, dated: String, memberName: String) {
        
        _imageID = imageID
        _dated = dated
        _memberName = memberName
        
    }
    
    
    
    
    
}
