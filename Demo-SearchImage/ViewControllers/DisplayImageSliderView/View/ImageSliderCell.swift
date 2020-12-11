//
//  ImageSliderCell.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 11/12/20.
//

import UIKit
import FSPagerView

class ImageSliderCell: FSPagerViewCell {
    static var nib : UINib {
        get {
            return UINib(nibName: "ImageSliderCell", bundle: Bundle.main)
        }
    }
    //Outlets
    @IBOutlet weak var displayNameView: UIView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var imgDisplayImage: UIImageView!
    
    //ConstraintOutLets
    @IBOutlet weak var cntBottomNameToViewSuperView: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func animateNameView() {
        cntBottomNameToViewSuperView.constant = -100
        self.layoutIfNeeded()
        
        DispatchQueue.main.async {
            self.cntBottomNameToViewSuperView.constant = 0
            
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }
}
