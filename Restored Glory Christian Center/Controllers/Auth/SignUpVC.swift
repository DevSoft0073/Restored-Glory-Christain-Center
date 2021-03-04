//
//  SignUpVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var checkUncheckButton: UIButton!
    @IBOutlet weak var lastNameView: UIView!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var nameTxtFld: UITextField!
    var unchecked = Bool()
    var messgae = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTxtFld{
            
            nameView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            lastNameView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }else if textField == lastName {
            
            nameView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            lastNameView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            
        }else if textField == emailTxtFld {
            
            nameView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            lastNameView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            passwordView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            
        } else if textField == passwordTxtFld {
            
            nameView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            lastNameView.borderColor = #colorLiteral(red: 0.9212896228, green: 0.9369686842, blue: 0.9718735814, alpha: 1)
            emailView.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            passwordView.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            
        }
    }
    
    
    func removeSpace() {
        if !nameTxtFld.text!.trimmingCharacters(in: .whitespaces).isEmpty {

            ValidateData(strMessage: " Please enter name")

        }else if !nameTxtFld.text!.trimmingCharacters(in: .whitespaces).isEmpty{

            ValidateData(strMessage: " Please enter email address")

        }else if isValidEmail(testStr: (emailTxtFld.text)!) == false{

            ValidateData(strMessage: "Enter valid email")

        }else if !nameTxtFld.text!.trimmingCharacters(in: .whitespaces).isEmpty{

            ValidateData(strMessage: " Please enter password")

        }else if (passwordTxtFld!.text!.count) < 4 || (passwordTxtFld!.text!.count) > 15{

            ValidateData(strMessage: "Please enter minimum 4 digit password")
            UserDefaults.standard.string(forKey: "password")

        } else if unchecked == false{

            ValidateData(strMessage: "Please agree with terms and conditions")
        }
        else{
            signUp()
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        
        if (nameTxtFld.text?.isEmpty)!{

            ValidateData(strMessage: " Please enter name")
            
        }else if (nameTxtFld.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{
            
            ValidateData(strMessage: "Please enter name")
            
        }else if (lastName.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter last name")
            
        }else if (lastName.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            
            ValidateData(strMessage: "Please enter last name")
        }
        else if (emailTxtFld.text?.isEmpty)!{

            ValidateData(strMessage: " Please enter email address")
        }
        else if isValidEmail(testStr: (emailTxtFld.text)!) == false{

            ValidateData(strMessage: "Enter valid email")
        }
        else if (passwordTxtFld.text?.isEmpty)!{

            ValidateData(strMessage: " Please enter password")
        }else if (passwordTxtFld!.text!.count) < 4 || (passwordTxtFld!.text!.count) > 15{

            ValidateData(strMessage: "Please enter minimum 4 digit password")
            UserDefaults.standard.string(forKey: "password")

        }
        else if unchecked == false{

            ValidateData(strMessage: "Please agree with terms and conditions")
        }
        else{
            signUp()
        }
    }
    
    @IBAction func checkUncheckButton(_ sender: Any) {
        if (unchecked == false)
        {
            checkUncheckButton.setBackgroundImage(UIImage(named: "check"), for: UIControl.State.normal)
            unchecked = true
        }
        else
        {
            checkUncheckButton.setBackgroundImage(UIImage(named: "uncheck"), for: UIControl.State.normal)
            unchecked = false
        }
    }
    
    @IBAction func termsAndConditionBUtton(_ sender: Any) {
    }
    
    @IBAction func gotoSignInButoon(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func signUp()  {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.SignUp
            let params = ["first_name":nameTxtFld.text ?? "","last_name" : lastName.text ?? "" ,"email":emailTxtFld.text ?? "", "password":passwordTxtFld.text ?? "" , "device_type" : "", "device_token" : ""] as [String : Any]
            AFWrapperClass.requestPOSTURL(url, params: params, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.messgae = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    self.nameTxtFld.text = ""
                    self.lastName.text = ""
                    self.emailTxtFld.text = ""
                    self.passwordTxtFld.text = ""
                    UserDefaults.standard.set(1, forKey: "tokenFString")
                    let allData = response as? [String:Any] ?? [:]
                    print(allData)
                    if let data = allData["data"] as? [String:Any]  {
                        UserDefaults.standard.set(data["user_id"], forKey: "id")
                        print(data)
                        showAlertMessage(title: Constant.shared.appTitle, message: self.messgae, okButton: "Ok", controller: self) {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                   
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
