//
//  BuddyScreen.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit
import Firebase
import FirebaseDatabase

class NameList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var membersTableView: UITableView!
    
    private var _groupName: Groups!
    
    var groupName: Groups {
        get {
            return _groupName
        } set {
            _groupName = newValue
        }
    }
    
    //TODO: Logic to Present Correct Members
    
    var membersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: This is a TEST
        let memberTest1 = Users(typeOfUser: "Member", userName: "John Adams", groupName: "Art World")
        let memberTest2 = Users(typeOfUser: "Member", userName: "Paul Smith", groupName: "Reach Out")
        
        membersArray.append(memberTest1)
        membersArray.append(memberTest2)
        
        membersTableView.delegate = self
        membersTableView.dataSource = self
    
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = membersTableView.dequeueReusableCell(withIdentifier: "NameListCell", for: indexPath) as? NameListCell {
            
            let memberName = membersArray[indexPath.row]
            
            cell.updateUI(usersName: memberName)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return membersArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let memberName = membersArray[indexPath.row]
        
        performSegue(withIdentifier: "ViewMemberArtwork", sender: memberName)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MembersCreativePieces {
            
            if let member = sender as? Users {
                
                destination.userName = member
            }
        }
    
    }
    
    

    @IBAction func backBtnPresssed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
