//
//  AppDelegate.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit
import IQKeyboardManagerSwift


func appDelegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
    //    setUpRootScreen()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func setUpRootScreen(){
        let viewController = UIStoryboard(name: "Spalsh", bundle: nil).instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.isNavigationBarHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func Logout1(){
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let nav = UINavigationController(rootViewController: homeViewController)
        nav.setNavigationBarHidden(true, animated: true)
        appdelegate.window?.rootViewController = nav
    }
    
    func getLoggedUser(){
        let credentials = UserDefaults.standard.value(forKey: "tokenFString") as? Int ?? 0
        if credentials == 1{
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
            let rootVc = storyBoard.instantiateViewController(withIdentifier: "SideMenuControllerID") as! SideMenuController
            let nav = UINavigationController(rootViewController: rootVc)
            nav.setNavigationBarHidden(true, animated: true)
            appdelegate.window?.rootViewController = nav
            appdelegate.window?.makeKeyAndVisible()
        }else if credentials == 0{
            
            let navigationController: UINavigationController? = (self.window?.rootViewController as? UINavigationController)
            let storyBoard = UIStoryboard.init(name: "Auth", bundle: nil)
            let rootVc = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            navigationController?.pushViewController(rootVc, animated: false)
            
        }
    }
    

}

