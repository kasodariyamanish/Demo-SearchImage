//
//  SearchListViewModel.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit

class SearchListViewModel {
    weak var vc: ViewController?
    
    func getImageList(queryStr:String,type:String,pageNumber:Int = 1) {
        if !Connectivity.isConnectedToInternet {
            self.vc?.alertOkay(title: Error.ALERT, message: Error.INTERNET_CONNECTION, okAction: {
                
            })
            return
         }
        ServiceCalss.post(url: "q=\(queryStr)&image_type=\(type)&page=\(pageNumber)") { (responseModel) in
            responseModel.toModel(completion: { (responseModel:ImagesResponseModel) in
                DispatchQueue.main.async {
                    var model = responseModel
                    if (self.vc?.imageListModel) != nil && pageNumber > 1{
                        self.vc?.imageListModel.pageNumber = pageNumber
                        self.vc?.imageListModel.hits.append(contentsOf: model.hits)
                    }
                    else{
                        if model.hits.count == 0 {
                            self.vc?.alertOkay(title: Error.ALERT, message: Error.IMAGE_NOT_FOUND)
                            return
                        }
                        model.pageNumber = 1
                        model.callAPIPageNumber = 1
                        self.vc?.imageListModel = model
                    }
                    self.vc?.searchStr = queryStr
                    self.vc?.tblImageList.reloadData()
                }
            })
        } failure: { (error) in
            self.vc?.alertOkay(title: Error.ALERT, message: error.errorDescription, okAction: {
                
            })
        }
    }
    
    
}
