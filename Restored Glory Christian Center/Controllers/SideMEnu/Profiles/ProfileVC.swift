//
//  ProfileVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 08/02/21.
//

import UIKit
import LGSideMenuController

class ProfileVC: UIViewController {

    @IBOutlet weak var addressTxtFld: UITextField!
    @IBOutlet weak var bioTxtView: UITextView!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxtFld.isUserInteractionEnabled = false
        addressTxtFld.isUserInteractionEnabled = false
        emailTxtFld.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    @IBAction func openMenu(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        sideMenuController?.showLeftViewAnimated()
    }
    
    func getData() {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.Profile
            print(signInUrl)
            let parms : [String:Any] = ["user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [String:Any]{
                        self.nameLbl.text = "\(allData["first_name"] as? String ?? "") " + "\(allData["last_name"] as? String ?? "")"
                        self.emailTxtFld.text = allData["email"] as? String ?? ""
                        self.bioTxtView.text = allData["description"] as? String ?? ""
                        self.addressTxtFld.text = allData["address"] as? String ?? ""
                        self.profileImage.sd_setImage(with: URL(string:allData["photo"] as? String ?? ""), placeholderImage: UIImage(named: "placehlder"))
                        self.flagImage.sd_setImage(with: URL(string:allData["flag_photo"] as? String ?? ""), placeholderImage: UIImage(named: "flag"))

                        let url = URL(string:allData["photo"] as? String ?? "")
                        if url != nil{
                            if let data = try? Data(contentsOf: url!)
                            {
                                if let image: UIImage = (UIImage(data: data)){
                                    self.profileImage.image = image
                                    self.profileImage.contentMode = .scaleToFill
                                    IJProgressView.shared.hideProgressView()
                                }
                            }
                        }
                        else{
                            self.profileImage.image = UIImage(named: "placehlder")
                        }
                        let urls = URL(string:allData["flag_photo"] as? String ?? "")
                        if urls != nil{
                            if let data = try? Data(contentsOf: urls!)
                            {
                                if let image: UIImage = (UIImage(data: data)){
                                    self.flagImage.image = image
                                    self.flagImage.contentMode = .scaleToFill
                                    IJProgressView.shared.hideProgressView()
                                }
                            }
                        }
                        else{
                            self.flagImage.image = UIImage(named: "flag")
                        }
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

    
    
    @IBAction func gotoEditVc(_ sender: Any) {
        let vc = EditProfileVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
