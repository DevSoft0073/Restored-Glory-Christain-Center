//
//  Men'sMinistryVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit
import LGSideMenuController

class Men_sMinistryVC: UIViewController {

    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var mensTbView: UITableView!
    var mensMinistryDataArray = [MensMinistryData]()
    var searchDataArray = [MensMinistryData]()
    var isSearch = false
    var message = String()
    override func viewDidLoad() {
        categoryDetails()
        mensTbView.separatorStyle = .none

        super.viewDidLoad()
        mensTbView.separatorStyle = .none
//        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        searchDataView.isHidden = true


    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
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
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchDataView.isHidden = true
        isSearch = false
        
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
            let parms : [String:Any] = ["c_id" : "4" , "search" : ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.mensMinistryDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [[String:Any]]{
                        for obj in allData{
                            self.mensMinistryDataArray.append(MensMinistryData(image: obj["image"] as? String ?? "", details: obj["description"] as? String ?? "", name: obj["title"] as? String ?? "", date: "21Dec", link: obj["link"] as? String ?? ""))
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
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension Men_sMinistryVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell
            = tableView.dequeueReusableCell(withIdentifier: "MensTbViewCell", for: indexPath) as! MensTbViewCell
        cell.showImage.image = UIImage(named: searchDataArray[indexPath.row].image)
        cell.titleLbl.text = searchDataArray[indexPath.row].name
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
