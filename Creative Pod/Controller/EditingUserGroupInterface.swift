//
//  EditingUserGroupInterface.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 20/02/2018.
//


import UIKit

class EditingUserGroupInterface: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var typePicker: UIPickerView!
    
    var typePickerData: [String] = [String]()
    
    @IBOutlet weak var groupPicker: UIPickerView!
    
    var groupPickerData: [String] = [String]()

    @IBOutlet weak var buddyPicker: UIPickerView!
    
    var buddyPickerData: [String] = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.typePicker.delegate = self
        self.typePicker.dataSource = self
        self.groupPicker.delegate = self
        self.groupPicker.dataSource = self
        self.buddyPicker.delegate = self
        self.buddyPicker.dataSource = self
        
        typePickerData = ["Member of Artlink", "Buddy", "Artist"]
        groupPickerData = ["Project X", "Project Y", "Project Z"]
        buddyPickerData = ["Sean", "Max", "Joe"]
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if pickerView.tag == 1 {
            return typePickerData.count
        } else if pickerView.tag == 2 {
            return groupPickerData.count
        } else {
            return buddyPickerData.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            return typePickerData[row]
        } else if pickerView.tag == 2 {
            return groupPickerData[row]
        } else {
            return buddyPickerData[row]
        }
    }
    
    @IBAction func saveChangesBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

