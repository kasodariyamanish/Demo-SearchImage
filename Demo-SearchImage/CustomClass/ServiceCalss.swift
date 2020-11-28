//
//  ServiceCalss.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON


class ServiceCalss {
    
    class func post(showLoader:Bool = true, loaderString:String = "Loading", url:String, success: @escaping (_ responseModel: JSON) -> Void, failure: @escaping (_ error: ErrorModel) -> Void) {
        let finalUrl = url.replacingOccurrences(of: " ", with: "%20")
        var request = URLRequest(url: URL(string: "\(Keys.BASE_URL)&\(finalUrl)")!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success(let result):
                
                if result.contains("[ERROR 400]") {
                    failure(ErrorModel(errorDescription: "Page is out of valid range.", errorCode: 400))
                    break
                }
                
                let json = JSON(parseJSON: result)
                print(json)
//                let responseModel = ResponseModel()
//                responseModel.total         = json["total"].int ?? 0
//                responseModel.totalHits     = json["totalHits"].int ?? 0
//                responseModel.json          = json["hits"]
                success(json)
                break
            case .failure(let error):
                print(error.localizedDescription)
                
                failure(ErrorModel(errorDescription: error.localizedDescription, errorCode: error.responseCode ?? 0))
                break
            }
        }
    }
}
