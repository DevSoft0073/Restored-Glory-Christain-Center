//
//  ChangePasswordVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 11/02/21.
//

import UIKit

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var confirmTxtView: UIView!
    @IBOutlet weak var confirmtxtFld: UITextField!
    @IBOutlet weak var newPasswordView: UIView!
    @IBOutlet weak var newPasswordtxtFld: UITextField!
    @IBOutlet weak var oldPasswordView: UIView!
    @IBOutlet weak var oldPasswordTxtFld: UITextField!
    var password = String()
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        if (oldPasswordTxtFld.text!.isEmpty){
            
            ValidateData(strMessage: "Please enter old password")
            
        }else if (password == oldPasswordTxtFld.text){
            
            ValidateData(strMessage: "Password matches")
            
        }else if (newPasswordtxtFld.text!.isEmpty){
            
            ValidateData(strMessage: "Please enter new password")
            
        }else if (newPasswordtxtFld!.text!.count) < 4 || (newPasswordtxtFld!.text!.count) > 15{
            
            ValidateData(strMessage: "Please enter minimum 4 digit password")
        }
        else if(confirmtxtFld.text!.isEmpty){
            
            ValidateData(strMessage: "Please enter confirm password")
            
        }
        else if newPasswordtxtFld.text != confirmtxtFld.text{
            
            ValidateData(strMessage: "New password and Confirm password should be same")
            
        }else if oldPasswordTxtFld.text == confirmtxtFld.text{
            
            ValidateData(strMessage: "New & old password should be different")
            
        }else{
            self.changePassword()
        }
        
        
    }
    
    func changePassword()  {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.ChangePassword
            print(signInUrl)
            let parms : [String:Any] = [ "user_id" : id, "new_password" : newPasswordtxtFld.text ?? "", "old_password" : oldPasswordTxtFld.text ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
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
    @IBAction func backButtonAction(_ sender: Any) {
    }
    
    
}
