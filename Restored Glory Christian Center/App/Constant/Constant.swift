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
    let appTitle  = "Restored Glory Christian Center"
    
    let baseUrl = "https://www.dharmani.com/Candaceyoung7/webservice/"
    let SignUp = "SignUp.php"
    let SignIn = "Login.php"
    let ForgotPassword = "ForgetPassword.php"
    
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
