//
//  Extensions.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit
import SwiftyJSON
import SDWebImage

extension KeyValuePairs {
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = String(format: "%@=%@",
                              String(describing: key).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                              String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            parts.append(part as String)
        }
        return parts.joined(separator: "&")
    }
}
extension JSON {
    func toListFromModel<T: Decodable>(completion: @escaping ([T]) -> ()) {
        let mainDict = arrayValue
        do {
            if let data = JSON(mainDict as Any).rawString(String.Encoding.utf8, options: JSONSerialization.WritingOptions.prettyPrinted)?.data(using: String.Encoding.utf8) {
                let obj = try JSONDecoder().decode([T].self, from:data)
                completion(obj)
            }
        } catch {
            print(error) // any decoding error will be printed here!
        }
    }
    
    func toModel<T: Decodable>(completion: @escaping (T) -> ()) {
        guard let mainDict = dictionaryObject else { return }
        do {
            let obj = try JSONDecoder().decode(T.self, from:mainDict.json.data(using: String.Encoding.utf8)!)
            completion(obj)
        } catch {
            print(error) // any decoding error will be printed here!
        }
    }
}

extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}
extension UIImageView {
    func loadImage(url:String,placeholderName:String){
        sd_imageIndicator = SDWebImageActivityIndicator.gray
        
        sd_setImage(with: URL(string: url)) { (image, error, cacheType, url) in
            if image != nil {
                self.image = image
            }
        }
    }
}

extension UIViewController{
    
    func present(vc: UIViewController, completion: (() -> Void)? = nil) {
        present(vc, animated: true, completion: completion)
    }
    
    func alertOkay(title:String, message:String, okAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        let okay  = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) { (action) in
            okAction?()
        }
        
        alert.addAction(okay)
        
        present(vc: alert)
    }
}

extension UITextField{
    var isEmpty : Bool {
        get{
            if self.text!.isEmpty || self.text!.empty{
                return true
            }
            return false
        }
    }
}

extension String{
    var empty: Bool {
        get {
            return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
        }
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
