//
//  ViewController.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit
class ViewController: UIViewController {

    @IBOutlet weak var txtSearch: SearchTextField!
    @IBOutlet weak var tblImageList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        /* Setup delegates */
//        tblImageList.delegate = self
//        tblImageList.dataSource = self
        txtSearch.delegate = self
        
    }

    @IBAction func didChange(_ sender: SearchTextField) {
        
    }
    func searchText(_ query: String) {
//        self.searchTF.filterStrings(arr)
    }
}


extension ViewController:UITextFieldDelegate{
    
}
