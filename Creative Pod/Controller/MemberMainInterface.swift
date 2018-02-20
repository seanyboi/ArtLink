//
//  MemberMainInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit

class MemberMainInterface: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    @IBAction func viewDesigns(_ sender: Any) {
        
        performSegue(withIdentifier: "MemberViewDesign", sender: nil)
        
    }
    
    @IBAction func createDesign(_ sender: Any) {
        
        performSegue(withIdentifier: "MembersCreate", sender: nil)
    }
    
    
    @IBAction func loggingOut(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
}

