//
//  ImageSelected.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 11/03/2018.
//

import Foundation

class ImageSelected {
    
    private var _imageID: String!
    private var _imageTag: Int!
    private var _groupName: String!
    
    var imageID: String {
        return _imageID
    }
    
    var imageTag: Int {
        return _imageTag
    }
    
    var groupName: String {
        return _groupName
    }
    
    
    init(imageID: String, imageTag: Int, groupName: String) {
        
        _imageID = imageID
        _imageTag = imageTag
        _groupName = groupName

        
    }
    
    
    
    
    
}
