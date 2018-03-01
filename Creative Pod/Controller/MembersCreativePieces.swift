//
//  MembersCreativePieces.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 19/02/2018.
//

import UIKit

class MembersCreativePieces: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var membersCollectionView: UICollectionView!
    @IBOutlet weak var membersNameLbl: UILabel!
    
    private var _userName: Users!
    
    //TODO: Possibly send through UID too if multiple same names
    
    var userName: Users {
        get {
            return _userName
        } set {
            _userName = newValue
        }
    }
    
    var imageArray = [Images]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Check if type is member 
        membersNameLbl.text = userName.userName
        
        membersCollectionView.delegate = self
        membersCollectionView.dataSource = self
        
        let memberImage1 = Images(imageID: 1, dated: "24/02/2018 - 4pm", memberName: "John Adams")
        let memberImage2 = Images(imageID: 2, dated: "25/02/2018 - 5pm", memberName: "Paul Smith")
        imageArray.append(memberImage1)
        imageArray.append(memberImage2)
        
        print(imageArray)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CreativeProductCell", for: indexPath) as? CreativeProductCell {
            
                let imageCell = imageArray[indexPath.row]
                cell.updateUI(image: imageCell)
                print(cell)
            
                return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let imageSelected = imageArray[indexPath.row]
        performSegue(withIdentifier: "ImageOfMemberViewed", sender: imageSelected)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ImagesViewed {
            
            if let image = sender as? Images {
                
                destination.memberImage = image
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imageArray.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 330, height: 330 )
        
    }
    
    
    @IBAction func backBtn(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
