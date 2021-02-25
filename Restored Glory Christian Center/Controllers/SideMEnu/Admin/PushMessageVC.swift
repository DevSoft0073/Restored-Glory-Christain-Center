//
//  PushMessageVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 08/02/21.
//

import UIKit

class PushMessageVC: UIViewController {

    @IBOutlet weak var titlelbl: UITextField!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageTxtView: UITextView!
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendButtonAction(_ sender: Any) {
        
        
        if (titlelbl.text?.isEmpty)!{
            
            ValidateData(strMessage: "Title should not empty")
            
        } else if (messageTxtView.text?.isEmpty)!{
            
            ValidateData(strMessage: "Message text view should not be empty")
            
        }else{
            
            self.sendPush()
            
        }
        
        sendPush()
    }
    
    func sendPush() {
        
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.SendPush
            print(signInUrl)
            let parms : [String:Any] = ["user_id" : id,"title" : titlelbl.text ?? "","description" : messageTxtView.text ?? ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    self.navigationController?.popViewController(animated: true)
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
