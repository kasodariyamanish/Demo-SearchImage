//
//  ShowImageVC.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit
import FSPagerView

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
    @IBOutlet weak var imageDisplayController: FSPagerView!{
        didSet {
            self.imageDisplayController.register(UINib(nibName:"ImageSliderCell", bundle: Bundle.main), forCellWithReuseIdentifier: CellIdentifier.SLIDER_CELL)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageDisplayController.delegate = self
        imageDisplayController.dataSource = self
        imageDisplayController.backgroundView?.isHidden = true
        DispatchQueue.main.async {
            self.imageDisplayController.scrollToItem(at: self.index, animated: false)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
}

//MARK: FSPageViewDataSource,Delegate
extension ShowImageVC:FSPagerViewDataSource,FSPagerViewDelegate{
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return hits.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.SLIDER_CELL, at: index) as! ImageSliderCell
        cell.imgDisplayImage.loadImage(url: hits[index].webformatURL, placeholderName: "")
        cell.lblUserName.text = "User : \(hits[index].user)"
        return cell
    }
    
    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        if let imageSliderCell = cell as? ImageSliderCell{
            imageSliderCell.animateNameView()
        }
    }
}
