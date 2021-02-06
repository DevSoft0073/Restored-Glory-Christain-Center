//
//  Constant.swift
//  racinewalker
//
//  Created by Vivek Dharmani on 7/1/20.
//  Copyright © 2020 Vivek Dharmani. All rights reserved.
//

import Foundation

class Constant: NSObject {
    
    static let shared = Constant()
    let appTitle  = "Pregnancy risk checker"
    let device_token = "1"
    let baseUrl = "https://www.dharmani.com/pregnancyApp/webservices/"
    
    let SignUP = "signUp.php"
    let SignIN = "logIn.php"
    let forgotPassword = "forgetPassword.php"
    let termsAndCondtion = "https://www.dharmani.com/pregnancyApp/TermsAndConditions.html"
    let aboutUS = "https://www.dharmani.com/pregnancyApp/AboutUs.html"
    let privecyPolicy = "https://www.dharmani.com/pregnancyApp/PrivacyPolicy.html"
    let ChangePassword = "changePassword.php"
    let profile = "getProfileDetails.php"
    let editProfile = "editProfile.php"
    let feedBack = "feedBack.php"
}

class Singleton  {
   static let sharedInstance = Singleton()
    var currentAddress = [String: Any]()
    var lat = Double()
    var long = Double()
    var authToken = String()
    var isComingFromSubDetailsScreen =  false
    var lastSelectedIndex = 0

}
