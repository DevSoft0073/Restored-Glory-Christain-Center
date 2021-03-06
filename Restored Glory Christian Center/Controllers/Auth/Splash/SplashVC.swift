//
//  SplashVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/03/21.
//

import UIKit

class SplashVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(navigateToLogin), userInfo: nil, repeats: false)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    @objc func navigateToLogin() {
        
        let credentials = UserDefaults.standard.value(forKey: "tokenFString") as? Int ?? 0
        if credentials == 1{
            let story = UIStoryboard(name: "Main", bundle: nil)
            let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
            self.navigationController?.pushViewController(rootViewController, animated: true)
        }else if credentials == 0{
            let vc = SignInVC.instantiate(fromAppStoryboard: .Auth)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
