//
//  GlobalVars.swift
//  Demo-SearchImage
//
//  Created by Manish's Mac on 28/11/20.
//

import UIKit
let defaults = UserDefaults.standard
class Keys {
    static let BASE_URL = "https://pixabay.com/api/?key=\(Keys.PIXABAY_API_KEY)"
    static let PIXABAY_API_KEY = "19299666-5492e41c94484d36d6c56676f"
}

class Error {
    static let ENTER_VALID_STRING = "Please enter valid string"
    static let INTERNET_CONNECTION = "Please check your internet connection and try again"
    static let ALERT = "Alert"
}

class CellIdentifier {
    static let IMAGE_CELL = "ImageCell"
}
