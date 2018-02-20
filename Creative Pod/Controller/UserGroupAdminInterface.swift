//
//  UserGroupAdminInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//


import UIKit

class UserGroupAdminInterface: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    
    @IBAction func addNewGroup(_ sender: Any) {
        
        
    }
    @IBAction func addNewUser(_ sender: Any) {
        
        performSegue(withIdentifier: "EditUsers", sender: nil)
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

