//
//  ViewController.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit

class LoginScreen: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var loginPicker: UIPickerView!
    
    var pickerData: [String] = [String]()
    
    @IBOutlet weak var nameLoginTxtField: UITextField!
    
    @IBOutlet weak var passwordLoginTxtField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginPicker.delegate = self
        self.loginPicker.dataSource = self
        
        pickerData = ["Member of Artlink", "Administrator", "Buddy", "Artist"]
        
    }
    
    //Number of columns of data in pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Number of rows of data in pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //Data to return for the row and component (column) thats being pass in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //Capture picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Method triggered whenever the user makes a change to picker selection.
    }

    


}

