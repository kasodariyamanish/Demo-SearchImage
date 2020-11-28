//
//  ImageCell.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit

class ImageCell: UITableViewCell {
    @IBOutlet weak var imgSearchImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    var hitModel:HitsModel!{
        didSet{
            imgSearchImage.loadImage(url: hitModel.webformatURL, placeholderName: "")
            lblUserName.text = "User : \(hitModel.user)"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
