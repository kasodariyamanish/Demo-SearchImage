//
//  ServiceCalss.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit
import Alamofire

class ResponseModel : NSObject {
    var total  : Int  = 0
    var totalHits      : Int    = 0
    var hits : [NSDictionary] = []
}

class ServiceCalss {
    
    class func createRequestParams(url:String , params: KeyValuePairs<String, String>) -> Data {
        let queryParams = params.queryParameters
        var stringToEncrypt = "\(url)"
        if !queryParams.isEmpty {
            stringToEncrypt.append("&")
            stringToEncrypt.append(queryParams)
        }
        
        return Data(stringToEncrypt.utf8)
    }
    
    class func post(showLoader:Bool = true, loaderString:String = "Loading", url:String, parameters:KeyValuePairs<String, String>, success: @escaping (_ responseModel: ResponseModel) -> Void, failure: @escaping (_ error: AFError) -> Void) {
        var request = URLRequest(url: URL(string: Keys.BASE_URL)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createRequestParams(url: url, params: parameters)
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success(let result):
                
                
                
                
                success(ResponseModel())
                break
            case .failure(let error):
                print(error.localizedDescription)
                
                failure(error)
                
                break
            }
        }
    }
}
