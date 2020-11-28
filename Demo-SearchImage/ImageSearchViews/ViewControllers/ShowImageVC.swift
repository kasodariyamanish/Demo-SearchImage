//
//  ShowImageVC.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit

class ShowImageVC: UIViewController {
    //Present Controller
    static var UI : ShowImageVC {
        get {
            return UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ShowImageVC") as! ShowImageVC
        }
    }
    
    //Variables
    var hits:[HitsModel] = []
    var index = 0
    
    //Outlets
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgDisplayImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateImage()
        
        
        //Left right swipe gesture
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
                                                        #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
                                                        #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(leftRecognizer)
        self.view.addGestureRecognizer(rightRecognizer)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            if hits.count > index + 1 {
                index += 1
                updateImage()
            }
        }
        if sender.direction == .right {
            if index - 1 > 0{
                index -= 1
                updateImage()
            }
        }
    }
    
    //display data
    func updateImage() {
        imgDisplayImage.loadImage(url: hits[index].webformatURL, placeholderName: "")
        lblUserName.text = "User : \(hits[index].user)"
    }
}
