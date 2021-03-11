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
    var messgae = String()
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
        
        if (emailTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email")
            
        } else if (passwordTxtFld.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
            
        }else{
            
            self.signIn()
            
        }
        
    }
    @IBAction func gotoSignUpVC(_ sender: Any) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Auth)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func signIn()  {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.SignIn
            var deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String ?? ""
            print(deviceID )
            if deviceID == nil  {
                deviceID = "777"
            }
            let params = ["email":emailTxtFld.text ?? "","password":passwordTxtFld.text ?? "" , "device_token" : deviceID ,"device_type" : "2"] as [String : Any]
            print(params)
            AFWrapperClass.requestPOSTURL(url, params: params, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.messgae = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    let allData = response as? [String:Any] ?? [:]
                    if let data = allData["data"] as? [String:Any]  {
                        UserDefaults.standard.set(1, forKey: "tokenFString")
                        UserDefaults.standard.set(data["user_id"], forKey: "id")
                        UserDefaults.standard.setValue(data["role"], forKey: "checkRole")
//                        UserDefaults.standard.set(data["role"], forKey: "checkRole")
//                        print(data)
                    }
                    let story = UIStoryboard(name: "Main", bundle: nil)
                    let rootViewController:UIViewController = story.instantiateViewController(withIdentifier: "SideMenuControllerID")
                    self.navigationController?.pushViewController(rootViewController, animated: true)
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.messgae, view: self)
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
