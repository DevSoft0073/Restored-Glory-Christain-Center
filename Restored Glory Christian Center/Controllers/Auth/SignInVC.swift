//
//  SignInVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit

class SignInVC: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var PasswordView: UIView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxtFld{
            
            emailView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            PasswordView.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }else if textField == passwordTxtFld {
            
            emailView.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            PasswordView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logInButton(_ sender: Any) {
        let vc = HomeVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func gotoSignUpVC(_ sender: Any) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
