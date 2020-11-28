//
//  SearchListModel.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import Foundation

struct ErrorModel {
    var errorDescription:String
    var errorCode:Int
}

struct ImagesResponseModel: Codable {
    var total  : Int
    var totalHits      : Int
    var pageNumber:Int? = 0
    var callAPIPageNumber:Int? = 0
    var hits:[HitsModel]
}

class HitsModel: Codable {
    let id:Int
    let pageURL:String
    let type:String
    let tags:String
    let previewURL:String
    let previewWidth:Int
    let previewHeight:Int
    let webformatURL:String
    let webformatWidth:Int
    let webformatHeight:Int
    let largeImageURL:String
    let imageWidth:Int
    let imageHeight:Int
    let imageSize:Int
    let views:Int
    let downloads:Int
    let favorites:Int
    let likes:Int
    let comments:Int
    let user_id:Int
    let user:String
    let userImageURL:String
}
