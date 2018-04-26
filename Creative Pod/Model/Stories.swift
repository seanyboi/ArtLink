//
//  Stories.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 10/03/2018.
//

import Foundation

import Foundation

/*
    @brief This class initiates a Stories object with the a story name, 4 images and 4 accompanying captions.
 
    @description Allow Stories objects to be past between controllers and data read from database to be stored within.
 */


class Stories {
    
    private var _storyName: String!
    private var _image1: String!
    private var _image2: String!
    private var _image3: String!
    private var _image4: String!
    private var _image1Text: String!
    private var _image2Text: String!
    private var _image3Text: String!
    private var _image4Text: String!
    
    var storyName: String {
        return _storyName
    }
    
    var image1: String {
        return _image1
    }
    var image2: String {
        return _image2
    }
    var image3: String {
        return _image3
    }
    var image4: String {
        return _image4
    }
    
    var image1Text: String {
        return _image1Text
    }
    var image2Text: String {
        return _image2Text
    }
    var image3Text: String {
        return _image3Text
    }
    var image4Text: String {
        return _image4Text
    }
    
    init(storyName: String, image1: String, image2: String, image3: String, image4: String, image1Text: String, image2Text: String, image3Text: String, image4Text: String ) {
        
        _storyName = storyName
        
        _image1 = image1
        _image2 = image2
        _image3 = image3
        _image4 = image4
        
        _image1Text = image1Text
        _image2Text = image2Text
        _image3Text = image3Text
        _image4Text = image4Text

        
    }
    
    
    
    
    
}
