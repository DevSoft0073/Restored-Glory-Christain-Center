//
//  ProfileVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 08/02/21.
//

import UIKit
import LGSideMenuController

class ProfileVC: UIViewController {

    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
//        sideMenuController?.showLeftViewAnimated()
    }
    
    
    @IBAction func gotoEditVc(_ sender: Any) {
        let vc = EditProfileVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
