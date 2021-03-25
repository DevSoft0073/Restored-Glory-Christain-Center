//
//  DetailsVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 10/02/21.
//

import UIKit
import SDWebImage


class DetailsVC: UIViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var searchTxtFld: UITextField!
    var detailsDataArray = [DetailsData]()
    var searchDataArray = [DetailsData]()
    var catId = String()
    var message = String()
    var isSearch = false
    var catName = String()
    @IBOutlet weak var detailsTbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDetails()
        detailsTbView.separatorStyle = .none
        detailsTbView.delegate = self
        detailsTbView.dataSource = self
        searchDataView.isHidden = true
        titleLbl.text = catName
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchDataView.isHidden = false
    }
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        if isSearch == false {
            searchDataView.isHidden = true
            categoryDetails()

        }else{
            searchDataView.isHidden = false
            isSearch = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchDataView.isHidden = true
        isSearch = false
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func searchTxtFldAction(_ sender: UITextField) {
        
        if searchTxtFld.text != ""{
            self.searchDataArray = self.detailsDataArray.filter{
                ($0.name).range(of: self.searchTxtFld.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            }
            detailsTbView.reloadData()
        }else{
            searchDataArray = detailsDataArray
            detailsTbView.reloadData()
        }
        detailsTbView.reloadData()
        
    }
    
    func categoryDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            var signInUrl = String()
            var parms = [String:Any]()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            if catName == "Upcoming Events"{
                signInUrl = Constant.shared.baseUrl + Constant.shared.GetAllUncomingEvents
                parms = ["user_id" : id ]
            }else{
                signInUrl = Constant.shared.baseUrl + Constant.shared.DetailsByCat
                parms = ["c_id" : catId , "search" : ""]
            }
            print(signInUrl)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.detailsDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [[String:Any]]{
                        for obj in allData{
                            let dateValue = obj["created_at"] as? String ?? ""
                            let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
                            self.detailsDataArray.append(DetailsData(image: obj["image"] as? String ?? "", details: obj["description"] as? String ?? "", name: obj["title"] as? String ?? "", date: self.convertTimeStampToDate(dateVal: dateVal), link: obj["link"] as? String ?? ""))
                        }
                    }
                    self.searchDataArray = self.detailsDataArray
                    self.detailsTbView.reloadData()
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

class DetailsTbViewCell: UITableViewCell {
    
    @IBOutlet weak var openLinkButton: UIButton!
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension DetailsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if searchDataArray.count == 0 {
                self.detailsTbView.setEmptyMessage("No data")
            } else {
                self.detailsTbView.restore()
            }
            return searchDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTbViewCell", for: indexPath) as! DetailsTbViewCell
        cell.nameLbl.text = searchDataArray[indexPath.row].name
        if catName == "Upcoming Events"{
            cell.detailsLbl.text = searchDataArray[indexPath.row].link
        }else{
            cell.detailsLbl.text = searchDataArray[indexPath.row].details
        }
        cell.dateLbl.text = searchDataArray[indexPath.row].date
        cell.showImage.sd_setImage(with: URL(string:searchDataArray[indexPath.row].image), placeholderImage: UIImage(named: "youth"))
                
        cell.openLinkButton.addTarget(self, action: #selector(clicked(_:)), for: .touchUpInside)
        cell.openLinkButton.tag = indexPath.row
        
        cell.dataView.layer.cornerRadius = 10
        cell.dataView.layer.masksToBounds = false
        cell.dataView?.layer.shadowColor = #colorLiteral(red: 0.7540688515, green: 0.7540867925, blue: 0.7540771365, alpha: 1)
        cell.dataView?.layer.shadowOffset =  CGSize.zero
        cell.dataView?.layer.shadowOpacity = 0.5
        cell.dataView?.layer.shadowRadius = 5
        
        
        return cell
    }
    
    @objc func clicked (_ btn:UIButton) {
        UIApplication.shared.open(URL(string: detailsDataArray[0].link)!, options: [:], completionHandler: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 10
        view.layer.shadowColor = #colorLiteral(red: 0.9044200033, green: 0.9075989889, blue: 0.9171359454, alpha: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
    }
    
}

struct DetailsData {
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
