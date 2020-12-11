//
//  ViewController.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var txtSearch: SearchTextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tblImageList: UITableView!{
        didSet{
            tblImageList.register(UINib(nibName: CellIdentifier.IMAGE_CELL, bundle: nil), forCellReuseIdentifier: CellIdentifier.IMAGE_CELL)
            tblImageList.dataSource = self
            tblImageList.delegate = self
        }
    }
    
    var imageListModel:ImagesResponseModel!
    var searchListViewModel = SearchListViewModel()
    var searchStr = "Animal"
    var searchKeyWordsArr:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let keyWordArr = defaults.value(forKey: "SearchKeyWords") as? [String]{
            searchKeyWordsArr = keyWordArr
        }
        txtSearch.delegate = self
        txtSearch.startVisible = true
        txtSearch.startVisibleWithoutInteraction =  true
        searchListViewModel.vc = self
        searchListViewModel.getImageList(queryStr: "", type: "photo",pageNumber: 1)
        
        txtSearch.setRightPaddingPoints(50)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onBtnSearch(_ sender: UIButton) {
        SearchImages()
    }
    
    
    func SearchImages() {
        if txtSearch.text == searchStr {
            return
        }
        else if (txtSearch.isEmpty){
            self.alertOkay(title: Error.ALERT, message: Error.ENTER_VALID_STRING)
            return
        }
        
        if var keyWordArr = defaults.value(forKey: "SearchKeyWords") as? [String]{
            if !keyWordArr.contains(txtSearch.text!) {
                if keyWordArr.count > 10 {
                    keyWordArr.removeLast()
                    keyWordArr.insert(txtSearch.text!, at: 0)
                    defaults.setValue(keyWordArr, forKey: "SearchKeyWords")
                    searchKeyWordsArr = keyWordArr
                }
                else{
                    keyWordArr.insert(txtSearch.text!, at: 0)
                    defaults.setValue(keyWordArr, forKey: "SearchKeyWords")
                    searchKeyWordsArr = keyWordArr
                }
            }
        }else{
            defaults.setValue([txtSearch.text!], forKey: "SearchKeyWords")
            searchKeyWordsArr = [txtSearch.text!]
        }
        defaults.synchronize()
        searchListViewModel.getImageList(queryStr: txtSearch.text!, type: "photo",pageNumber: 1)
    }
}

extension ViewController:UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchImages()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        let filterdItemsArray = searchKeyWordsArr.filter { item in
            return item.lowercased().contains(searchText.lowercased())
        }
        
        self.txtSearch.filterStrings(filterdItemsArray.count == 0 ? searchKeyWordsArr : filterdItemsArray)
        
        return true
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.txtSearch.filterStrings(searchKeyWordsArr)
        self.txtSearch.textFieldDidChange()
    }
    
    func filterContentForSearchText(searchText: String) {
        
    }
}
extension ViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageListModel != nil ? imageListModel.hits.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.IMAGE_CELL, for: indexPath) as! ImageCell
        cell.hitModel = imageListModel.hits[indexPath.row]
        return cell
    }
}

extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.size.width * 200.0)/414.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let listModel = imageListModel {
            if indexPath.row > listModel.hits.count - 5 {
                guard let pageNumber = imageListModel.pageNumber else {
                    return
                }
                guard let callAPIPageNumber = imageListModel.callAPIPageNumber else {
                    return
                }
                if callAPIPageNumber > pageNumber {
                    return
                }
                imageListModel?.callAPIPageNumber = pageNumber + 1
                searchListViewModel.getImageList(queryStr: searchStr, type: "photo",pageNumber: pageNumber + 1)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showImage = ShowImageVC.UI
        showImage.hits = imageListModel.hits
        showImage.index = indexPath.row
        self.navigationController?.pushViewController(showImage, animated: true)
        
    }
}
