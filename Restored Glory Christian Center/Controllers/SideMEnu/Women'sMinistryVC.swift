//
//  Women'sMinistryVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit

class Women_sMinistryVC: UIViewController {

    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var womensDataTBVIew: UITableView!
    var womenDataArray = [WomensData]()
    var searchDataArray = [WomensData]()
    var isSearch = false
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDetails()
        
//        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
//        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
//        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
//        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
//        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
//        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
//        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        searchDataView.isHidden = true

        womensDataTBVIew.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchDataView.isHidden = true
        isSearch = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchDataView.isHidden = true
        isSearch = false
    }
    
    @IBAction func searchButton(_ sender: Any) {
        isSearch = true
        if isSearch == false {
            searchDataView.isHidden = true
            
        }else{
            searchDataView.isHidden = false
            isSearch = false
        }
    }
    
    @IBAction func searchtxtFldAction(_ sender: UITextField) {
        if searchTxtFld.text != ""{
            self.searchDataArray = self.womenDataArray.filter{
                ($0.name).range(of: self.searchTxtFld.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            }
            womensDataTBVIew.reloadData()
        }else{
            searchDataArray = womenDataArray
            womensDataTBVIew.reloadData()
        }
        womensDataTBVIew.reloadData()
    }
    
    func categoryDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.DetailsByCat
            print(signInUrl)
            let parms : [String:Any] = ["c_id" : "3" , "search" : ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.womenDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [[String:Any]]{
                        for obj in allData{
                            self.womenDataArray.append(WomensData(image: obj["image"] as? String ?? "", details: obj["description"] as? String ?? "", name: obj["title"] as? String ?? "", date: "21Dec", link: obj["link"] as? String ?? ""))
                        }
                    }
                    self.searchDataArray = self.womenDataArray
                    self.womensDataTBVIew.reloadData()
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

class WomensDataTBVIewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension Women_sMinistryVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WomensDataTBVIewCell", for: indexPath) as! WomensDataTBVIewCell
        cell.titleLbl.text = searchDataArray[indexPath.row].name
        cell.showImage.image = UIImage(named: searchDataArray[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}

struct WomensData {
    var image : String
    var details : String
    var name : String
    var date : String
    var link : String
    
    init(image : String , details : String , name : String , date : String , link : String) {
        
        self.image = image
        self.details = details
        self.name = name
        self.date = date
        self.link = link
    }
}
