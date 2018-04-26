//
//  AdminInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//

import UIKit

class AdminInterface: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    @IBAction func adminViewDesigns(_ sender: Any) {
        
        performSegue(withIdentifier: "AdminViewDesigns", sender: nil)
        
    }
    @IBAction func adminUsersGroups(_ sender: Any) {
        
        performSegue(withIdentifier: "UsersGroups", sender: nil)
    }
    
    @IBAction func loggingOut(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
