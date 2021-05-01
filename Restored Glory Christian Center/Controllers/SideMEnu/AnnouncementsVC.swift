//
//  AnnouncementsVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit
import LGSideMenuController

class AnnouncementsVC: UIViewController {
    
    @IBOutlet weak var titlelbl: UILabel!
    var message = String()
    @IBOutlet weak var adminTBView: UITableView!
    var adminTBDataArray = [AdminTBData]()
    var isSearch = false
    var catID = String()
    var catTitle = String()
    var searchDataArray = [AdminTBData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adminTBView.separatorStyle = .none
        adminTBView.separatorStyle = .none
        
        titlelbl.text = catTitle
        if catTitle == "Encouraging Words" {
            categoryListing()
        }else{
            categoryDetails()
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func categoryListing() {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let signInUrl = Constant.shared.baseUrl + Constant.shared.GetAllLinks
            let parms = ["user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.adminTBDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [[String:Any]]{
                        for obj in allData{
                            
                            self.adminTBDataArray.append(AdminTBData(image: obj["image"] as? String ?? "", name: obj["title"] as? String ?? "", details: obj["description"] as? String ?? "", date: ""))
                        }
                    }
                    self.searchDataArray = self.adminTBDataArray
                    self.adminTBView.reloadData()
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
    
    func categoryDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            
            var signInUrl = String()
            var parms = [String:Any]()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            if catTitle == "Upcoming Events"{
                signInUrl = Constant.shared.baseUrl + Constant.shared.GetAllUncomingEvents
                parms = ["user_id" : id ]
            }else{
                signInUrl = Constant.shared.baseUrl + Constant.shared.DetailsByCat
                parms = ["c_id" : catID , "search" : ""]
            }
            print(signInUrl)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.adminTBDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [[String:Any]]{
                        for obj in allData{
                            self.adminTBDataArray.append(AdminTBData(image: obj["image"] as? String ?? "", name: obj["title"] as? String ?? "", details: obj["description"] as? String ?? "", date: ""))
                        }
                    }
                    self.searchDataArray = self.adminTBDataArray
                    self.adminTBView.reloadData()
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

class AdminTBView_Cell: UITableViewCell {
    
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AnnouncementsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminTBDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminTBView_Cell", for: indexPath) as! AdminTBView_Cell
        //        cell.profileImage.image = UIImage(named: adminTBDataArray[indexPath.row].image)
        cell.profileImage.sd_setImage(with: URL(string:searchDataArray[indexPath.row].image), placeholderImage: UIImage(named: "placehlder"))
        cell.nameLbl.text = adminTBDataArray[indexPath.row].name
        cell.detailLbl.text = adminTBDataArray[indexPath.row].details
        //        DispatchQueue.main.async {
        //            self.heightConstraint.constant = CGFloat(self.adminTBView.contentSize.height)
        //        }
        cell.profileImage.setRounded()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

struct AdminTBData {
    var image : String
    var name : String
    var details : String
    var date : String
    
    init(image : String , name : String , details : String,date : String) {
        self.image = image
        self.name = name
        self.details = details
        self.date = date
    }
}
