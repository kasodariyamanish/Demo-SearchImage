//
//  ViewController.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit
import SwiftyJSON
class ViewController: UIViewController {

    @IBOutlet weak var txtSearchBar: UISearchBar!
    @IBOutlet weak var searchTextTableView: UIView!
    @IBOutlet weak var tblImageList: UITableView!{
        didSet{
            tblImageList.register(UINib(nibName: CellIdentifier.IMAGE_CELL, bundle: nil), forCellReuseIdentifier: CellIdentifier.IMAGE_CELL)
            tblImageList.dataSource = self
            tblImageList.delegate = self
        }
    }
    
    @IBOutlet weak var constraintHeightSearchTextVC: NSLayoutConstraint!
    
    var searchTextVC:SearchTextVC?
    var imageListModel:ImagesResponseModel!
    var searchListViewModel = SearchListViewModel()
    var searchStr = "Animal"
    var searchKeyWordsArr:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        if let keyWordArr = defaults.value(forKey: "SearchKeyWords") as? [String]{
            searchKeyWordsArr = keyWordArr
        }
        txtSearchBar.delegate = self
        searchListViewModel.vc = self
        searchListViewModel.getImageList(queryStr: "", type: "photo",pageNumber: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func SearchImages(searchText:String) {
        if searchText == searchStr {
            return
        }
        else if (searchText.isEmpty){
            self.alertOkay(title: Error.ALERT, message: Error.ENTER_VALID_STRING)
            return
        }
        
        if var keyWordArr = defaults.value(forKey: "SearchKeyWords") as? [String]{
            if !keyWordArr.contains(searchText) {
                if keyWordArr.count > 10 {
                    keyWordArr.removeLast()
                    keyWordArr.insert(searchText, at: 0)
                    defaults.setValue(keyWordArr, forKey: "SearchKeyWords")
                    searchKeyWordsArr = keyWordArr
                }
                else{
                    keyWordArr.insert(searchText, at: 0)
                    defaults.setValue(keyWordArr, forKey: "SearchKeyWords")
                    searchKeyWordsArr = keyWordArr
                }
            }
        }else{
            defaults.setValue([searchText], forKey: "SearchKeyWords")
            searchKeyWordsArr = [searchText]
        }
        defaults.synchronize()
        searchListViewModel.getImageList(queryStr: searchText, type: "photo",pageNumber: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchTextVC" {
            if let vc = segue.destination as? SearchTextVC{
                searchTextVC = vc
            }
        }
    }
}

//MARK: Searchbar delegate
extension ViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBarText(searchText: searchText)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchBarText(searchText: searchText)
        }
    }
    
    func searchBarText(searchText:String) {
        let searchTextStr = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        let filtered = searchKeyWordsArr.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchTextStr, options: .caseInsensitive)
                    return range.location != NSNotFound
                })
        
        if(filtered.count > 0){
            self.searchTextTableView.isHidden = false
            if let searchTextVc = searchTextVC{
                searchTextVc.searchTextArr = filtered
                searchTextVc.reloadTable()
            }
        }
        else if searchKeyWordsArr.count > 0 && searchTextStr == ""{//empty searchbar
            self.searchTextTableView.isHidden = false
            if let searchTextVc = searchTextVC{
                searchTextVc.searchTextArr = searchKeyWordsArr
                searchTextVc.reloadTable()
            }
        }
        else{
            self.searchTextTableView.isHidden = true
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchTextTableView.isHidden = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        var searchText = ""
        if let text = searchBar.text{
            searchText = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
        SearchImagesFromSearchText(searchText: searchText)
    }
    
    func SearchImagesFromSearchText(searchText:String) {
        self.searchTextTableView.isHidden = true
        self.txtSearchBar.text = searchText
        SearchImages(searchText: searchText)
        self.txtSearchBar.resignFirstResponder()
    }
}

//MARK: Tableview datasource
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


//MARK: Tableview delegate
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
        self.searchTextTableView.isHidden = true
        self.txtSearchBar.resignFirstResponder()
        
        let showImage = ShowImageVC.UI
        showImage.hits = imageListModel.hits
        showImage.index = indexPath.row
        self.navigationController?.pushViewController(showImage, animated: true)
        
    }
}
