//
//  Men'sMinistryVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit
import LGSideMenuController

class Men_sMinistryVC: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var mensTbView: UITableView!
    var mensMinistryDataArray = [MensMinistryData]()
    var searchDataArray = [MensMinistryData]()
    var titleName = String()
    var id = String()
    var isSearch = false
    var message = String()
    override func viewDidLoad() {
        categoryDetails()
        titleLbl.text = titleName
        mensTbView.separatorStyle = .none
        searchDataView.isHidden = true
        mensTbView.delegate = self
        mensTbView.dataSource = self
        super.viewDidLoad()
    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchDataView.isHidden = false
      
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        if isSearch == false {
            searchDataView.isHidden = true
            categoryDetails()
            searchTxtFld.text = ""

        }else{
            searchDataView.isHidden = false
            isSearch = false
        }
    }
    @IBAction func searchTxtFldAction(_ sender: UITextField) {
        
        if searchTxtFld.text != ""{
            self.searchDataArray = self.mensMinistryDataArray.filter{
                ($0.name).range(of: self.searchTxtFld.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            }
            mensTbView.reloadData()
        }else{
            searchDataArray = mensMinistryDataArray
            mensTbView.reloadData()
        }
        mensTbView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchDataView.isHidden = true
        isSearch = false
    }
    
    func categoryDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.DetailsByCat
            print(signInUrl)
            let parms : [String:Any] = ["c_id" : id , "search" : ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.mensMinistryDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [[String:Any]]{
                        for obj in allData{
                            let dateValue = obj["created_at"] as? String ?? ""
                            let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
                            self.mensMinistryDataArray.append(MensMinistryData(image: obj["image"] as? String ?? "", details: obj["description"] as? String ?? "", name: obj["title"] as? String ?? "", date: obj["servercreated_at"] as? String ?? "", link: obj["link"] as? String ?? ""))
                        }
                    }
                    self.searchDataArray = self.mensMinistryDataArray
                    self.mensTbView.reloadData()
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

class MensTbViewCell: UITableViewCell {
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension Men_sMinistryVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchDataArray.count == 0 {
                self.mensTbView.setEmptyMessage("No data")
            } else {
                self.mensTbView.restore()
            }
            return searchDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MensTbViewCell", for: indexPath) as! MensTbViewCell
        cell.showImage.sd_setImage(with: URL(string:searchDataArray[indexPath.row].image), placeholderImage: UIImage(named: "ic_ph_home"))
        cell.titleLbl.text = searchDataArray[indexPath.row].details
        cell.nameLbl.text = searchDataArray[indexPath.row].name
        cell.dateLbl.text = searchDataArray[indexPath.row].date
        cell.dataView.layer.cornerRadius = 10
        cell.dataView.layer.masksToBounds = false
        cell.dataView?.layer.shadowColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        cell.dataView?.layer.shadowOffset =  CGSize.zero
        cell.dataView?.layer.shadowOpacity = 0.5
        cell.dataView?.layer.shadowRadius = 5
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIApplication.shared.open(URL(string: searchDataArray[0].link)!, options: [:], completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
}

struct MensMinistryData {
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
