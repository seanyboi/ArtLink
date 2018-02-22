//
//  MembersCreativePieces.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit

class MembersCreativePieces: UIViewController {
    
    
    @IBOutlet weak var membersNameLbl: UILabel!
    
    private var _userName: Users!
    
    var userName: Users {
        get {
            return _userName
        } set {
            _userName = newValue
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Check if type is member 
        membersNameLbl.text = userName.userName
        
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
