//
//  SignUpVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTxtFld{
            
            nameView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }else if textField == emailTxtFld {
            
            nameView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            
        } else if textField == passwordTxtFld {
            
            nameView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passwordView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
    }
    
    @IBAction func checkUncheckButton(_ sender: Any) {
    }
    
    @IBAction func termsAndConditionBUtton(_ sender: Any) {
    }
    
    @IBAction func gotoSignInButoon(_ sender: Any) {
    }

}
