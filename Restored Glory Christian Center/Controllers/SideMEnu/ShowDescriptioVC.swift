//
//  ShowDescriptioVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 01/05/21.
//

import UIKit
import Foundation
import LGSideMenuController
import SDWebImage

class ShowDescriptioVC : UIViewController {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var tblData: UITableView!
    var catId = String()
    var message = String()
    var isSearch = false
    var catName = String()
    var details = String()
    var catID = String()
    var catTitle = String()
    var adminTBDataArray = [AdminTBData]()
    var searchDataArray = [AdminTBData]()
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: Custome
    
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
                            self.adminTBDataArray.append(AdminTBData(image: obj["image"] as? String ?? "", name: obj["title"] as? String ?? "", details: obj["description"] as? String ?? "", date: obj["servercreated_at"] as? String ?? ""))
                        }
                    }
                    self.searchDataArray = self.adminTBDataArray
                    self.tblData.reloadData()
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
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDetails()
        titleLbl.text = catTitle
        self.tblData.separatorStyle = .none
        tblData.separatorStyle = .none
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    
    @IBAction func openMenu(_ sender: Any) {
        
        let comesFrom = UserDefaults.standard.value(forKey: "sideMenu") as? Bool ?? true
        if comesFrom == true {
            sideMenuController?.showLeftViewAnimated()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
}

class TblDataCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ShowDescriptioVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminTBDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TblDataCell", for: indexPath) as! TblDataCell
        cell.showImage.sd_setShowActivityIndicatorView(true)
        cell.showImage.sd_setIndicatorStyle(.gray)
        cell.showImage.sd_setImage(with: URL(string:searchDataArray[indexPath.row].image), placeholderImage: UIImage(named: ""))
        cell.titleLbl.text = adminTBDataArray[indexPath.row].name
        cell.dataLbl.text = adminTBDataArray[indexPath.row].details
        cell.datelbl.text = adminTBDataArray[indexPath.row].date
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
