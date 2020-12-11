//
//  SearchTextVC.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 11/12/20.
//

import UIKit

class SearchTextVC: UIViewController {

    @IBOutlet weak var tblSearchTextList: UITableView!
    var searchTextArr:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblSearchTextList.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblSearchTextList.delegate = self
        tblSearchTextList.dataSource = self
    }
    
    func reloadTable() {
        tblSearchTextList.reloadData()
        if let perentVC = self.parent as? ViewController{
            perentVC.constraintHeightSearchTextVC.constant = CGFloat(searchTextArr.count) * 45.0
        }
    }
    
}

//MARK: Tableview datasource and delegate
extension SearchTextVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTextArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        cell.textLabel?.text = self.searchTextArr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let perentVC = self.parent as? ViewController{
            perentVC.SearchImagesFromSearchText(searchText: self.searchTextArr[indexPath.row])
        }
    }
}
