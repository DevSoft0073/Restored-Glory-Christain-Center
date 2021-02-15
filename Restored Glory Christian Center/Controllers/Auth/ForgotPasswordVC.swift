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
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxtFld{
            
            emailView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            
        }
        
    }
    
    @IBAction func backBUttonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        if (emailTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email")
        }
        else if isValidEmail(testStr: (emailTxtFld.text)!) == false{
            
            ValidateData(strMessage: "Enter valid email")
            
        }else{
            forgotPassword()
        }
    }
    
    func forgotPassword() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.ForgotPassword
            print(signInUrl)
            let parms : [String:Any] = ["email":emailTxtFld.text ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
//                    UserDefaults.standard.set(true, forKey: "tokenFString")
                    showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "OK", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }
    
}
