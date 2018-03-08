//
//  EditingUsers.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 08/03/2018.
//

import UIKit
import FirebaseDatabase
import Firebase

class EditingUserInterface: UIViewController {
    
    private var _userName: Users!
    
    var userName: Users {
        get {
            return _userName
        } set {
            _userName = newValue
        }
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    
    
    override func viewDidLoad() {
        
        nameLbl.text = userName.userName
        
        
        
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
}
