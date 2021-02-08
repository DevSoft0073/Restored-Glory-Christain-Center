//
//  ForgotPasswordVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit

class ForgotPasswordVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxtFld{
            
            emailView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            
        }
        
    }
    
    @IBAction func backBUttonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
    }
    
}
