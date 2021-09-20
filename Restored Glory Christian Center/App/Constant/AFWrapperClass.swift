//
// AFWrapperClass.swift
// Attire4hire
//
//  Created by Vivek Dharmani on 06/01/20.
// Copyright © 2020 Apple. All rights reserved.
//
//
import Foundation
import UIKit
import Alamofire
import Branch

class AFWrapperClass{
    
    
    class func requestPOSTURL(_ strURL : String, params : Parameters, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        success(JSON as NSDictionary)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }
    }
    class func requestUrlEncodedPOSTURL(_ strURL : String, params : Parameters, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
           let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/x-www-form-urlencoded"])
               .responseJSON { (response) in
                   switch response.result {
                   case .success(let value):
                       if let JSON = value as? [String: Any] {
                        if response.response?.statusCode == 200{
                           success(JSON as NSDictionary)
                        }else if response.response?.statusCode == 400{
                            let error : NSError = NSError(domain: "invalid user details", code: 400, userInfo: [:])
                            failure(error)
                       }
                    }
                   case .failure(let error):
                       let error : NSError = error as NSError
                       failure(error)
                   }
           }
       }
    class func requestGETURL(_ strURL: String, params : [String : AnyObject]?, success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void) {
        
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .get, parameters: params, encoding: JSONEncoding.default)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? Any {
                        success(JSON as AnyObject)
                        print(JSON)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    failure(error)
                }
        }
    }
    
    class func createContentDeepLink(title: String,type: String,OtherId: String, description: String, image: String?,link: String,completion: @escaping (String?) -> ()) {
        let buo = BranchUniversalObject(canonicalIdentifier: UUID().uuidString)
        buo.canonicalUrl = "http://mobile.restoredglory.org/RestoredGloryChristianCenter/"
        buo.publiclyIndex = false
        buo.locallyIndex = false
        buo.title = title
        buo.contentDescription = description
        if image != "" {
            buo.imageUrl = image
        }
        let linkLP: BranchLinkProperties =  BranchLinkProperties()
        linkLP.addControlParam("link", withValue: link)
        linkLP.addControlParam("OtherID", withValue: OtherId)
        linkLP.addControlParam("type", withValue: type)
        linkLP.addControlParam("environment", withValue: AFWrapperClass.returnEnv().rawValue)
        buo.getShortUrl(with: linkLP) { (url, error) in
            if error == nil {
                completion(url)
            }
        }
    }
    
    class func presentShare(objectsToShare: [Any], vc: UIViewController) {
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = vc.view
        activityVC.popoverPresentationController?.sourceRect = vc.view.frame
        vc.present(activityVC, animated: true, completion: nil)
    }
    
    class func returnEnv()->Env{
        return Constant.shared.baseUrl == "http://mobile.restoredglory.org/RestoredGloryChristianCenter/webservice/" ? .prod : .dev
    }
    enum Env:String{
        case dev
        case prod
    }
    class func returnCurrentUserId()->String{
        return UserDefaults.standard.value(forKey: "Uid") as? String ?? ""
    }
    
    static func redirectToTabNavRVC(currentVC: UIViewController){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Tab") as! SideMenuController
//        vc.isFrom = "push"
//        let nav = UINavigationController(rootViewController: vc)
//        nav.setNavigationBarHidden(true, animated: false)
//        if #available(iOS 13.0, *){
//            if let scene = UIApplication.shared.connectedScenes.first{
//                guard let windowScene = (scene as? UIWindowScene) else { return }
//                print(">>> windowScene: \(windowScene)")
//                let window: UIWindow = UIWindow(frame: windowScene.coordinateSpace.bounds)
//                window.windowScene = windowScene //Make sure to do this
//                window.rootViewController = nav
//                window.makeKeyAndVisible()
//                appDelegate.window = window
//            }
//        } else {
//            appDelegate.window?.rootViewController = nav
//            appDelegate.window?.makeKeyAndVisible()
//        }
        
//        func setUpInitialScreen(){
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let story = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
            let nav = UINavigationController(rootViewController: rootViewController)
            nav.setNavigationBarHidden(true, animated: true)
            appdelegate.window?.rootViewController = nav
//        }
        
    }
    
}

extension UIViewController {
    func isValidUsername(testStr:String) -> Bool
    {
        let emailRegEx = ".*[^A-Za-z].*"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
