//
//  ShowLinksVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 17/02/21.
//

import UIKit
import LGSideMenuController

class ShowLinksVC: UIViewController {

    var showLinksDataArray = [ShowLinksData]()
    var searchDataArray = [ShowLinksData]()
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var showLinksTbView: UITableView!
    var isSearch = false
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showLinksTbView.reloadData()
        categoryListing()
        searchView.isHidden = true
        showLinksTbView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }

    @IBAction func searchButton(_ sender: Any) {
        
        isSearch = true
        if isSearch == false {
            searchView.isHidden = true
            isSearch = false
            
        }else{
            
            searchView.isHidden = false
            isSearch = false
            
        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
        
        sideMenuController?.showLeftViewAnimated()
        
    }
    
    @IBAction func addLinkbuttonAction(_ sender: Any) {
        
        let vc = AddLinkVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchView.isHidden = true
//        categoryListing()
        isSearch = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchView.isHidden = true
        isSearch = false
    }
    
    
    func categoryListing() {
        
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.CategoryType
            print(signInUrl)
            let parms : [String:Any] = ["userID" : id , "search" : ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.showLinksDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["category_details"] as? [[String:Any]]{
                        for obj in allData{
                            self.showLinksDataArray.append(ShowLinksData(image: obj[""] as? String ?? "", name: obj["name"] as? String ?? ""))
                        }
                    }
                    self.searchDataArray = self.showLinksDataArray
                    self.showLinksTbView.reloadData()
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

class ShowLinksTbViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ShowLinksVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowLinksTbViewCell", for: indexPath) as! ShowLinksTbViewCell
        cell.titleLbl.text = searchDataArray[indexPath.row].name
        cell.showImage.sd_setImage(with: URL(string:searchDataArray[indexPath.row].image), placeholderImage: UIImage(named: "youth"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}


struct ShowLinksData {
    var image : String
    var name : String
    
    init(image : String , name : String ) {
        self.image = image
        self.name = name
    }
}
