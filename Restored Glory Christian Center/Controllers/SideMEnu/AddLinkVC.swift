//
//  AddLinkVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit

class AddLinkVC: UIViewController {
    
    
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var addlinkTxtFld: UITextField!
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var selectTypeTxtFld: UITextField!
    @IBOutlet weak var showUploadImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
    }
    
    @IBAction func openPickerView(_ sender: Any) {
    }
    @IBAction func submitButtonAction(_ sender: Any) {
    }
    
}
