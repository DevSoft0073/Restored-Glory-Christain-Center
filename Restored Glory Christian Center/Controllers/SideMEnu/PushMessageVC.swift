//
//  PushMessageVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 08/02/21.
//

import UIKit

class PushMessageVC: UIViewController {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
    }
    
}
