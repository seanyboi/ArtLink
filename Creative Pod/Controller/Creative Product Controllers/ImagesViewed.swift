//
//  ImagesViewed.swift
//  Creative Pod
//
//  Created by Sean O'Connor on 24/02/2018.
//

import UIKit

/*
 
 @brief This class determines behaviour of the ImagesViewed.swift interface used by an all Users to view a larger image of the one selected.
 
 */

class ImagesViewed: UIViewController {
    
    @IBOutlet weak var imageOfMember: UIImageView!
    
    //Getter and setter to ensure that an image is recieved and nothing else.
    
    private var _image: Images!
    
    var memberImage: Images {
        get {
            return _image
        } set {
            _image = newValue
        }
    }
    
    let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView (activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Loading spinner that symbolises the image is loading, app cannot be used until action complete.
        
        activityIndicator.color = .blue
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.bringSubview(toFront: self.view)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        downloadingImage()
        
        
    }
    
    //Function to download the image using the URL that was passed from previous interface.
    
    func downloadingImage() {
        
        let imageURLConversion = URL(string: memberImage.imageID)
        URLSession.shared.dataTask(with: imageURLConversion!, completionHandler: { (data, response, error) in
            
            if error == nil {
                
                DispatchQueue.main.async {
                    self.imageOfMember.image = UIImage(data: data!)
                    self.imageOfMember.isHidden = false
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
                
            } else {
                print(error as Any)
                return
            }
            
        }).resume()
        
    }
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}
