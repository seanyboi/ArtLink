//
//  GroupList.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit

class GroupList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var groupTableView: UITableView!
    
    var groupArray = [Groups]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: This is a TEST
        let groupTest1 = Groups(groupName: "Art World")
        let groupTest2 = Groups(groupName: "Reach Out")
        
        groupArray.append(groupTest1)
        groupArray.append(groupTest2)
        
        groupTableView.delegate = self
        groupTableView.dataSource = self
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = groupTableView.dequeueReusableCell(withIdentifier: "GroupListCell", for: indexPath) as? GroupListCell {
            
            let groupName = groupArray[indexPath.row]
            
            cell.updateUI(groupsName: groupName)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groupArray.count
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let groupName = groupArray[indexPath.row]
        
        performSegue(withIdentifier: "ViewMembersInGroup", sender: groupName)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? NameList {
            
            if let group = sender as? Groups {
                
                destination.groupName = group
                
            }
        }
        
    }
    
    @IBAction func loggingOut(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

