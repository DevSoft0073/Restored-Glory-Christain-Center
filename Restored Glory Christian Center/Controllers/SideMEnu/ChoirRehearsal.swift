//
//  ChoirRehearsal.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 10/02/21.
//

import UIKit
import LGSideMenuController

class ChoirRehearsal: UIViewController {
    
    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var searchTxtFld: UITextField!
    var ChoirRehearsalDataArray = [ChoirRehearsalData]()
    var searchDataArray = [ChoirRehearsalData]()
    var isSearch = false
    var message = String()
    @IBOutlet weak var dataTbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDataView.isHidden = true
        categoryDetails()
        dataTbView.separatorStyle = .none

//        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
//        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
//        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
//        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
//        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
//        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
//        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButton(_ sender: Any) {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchDataView.isHidden = true
        isSearch = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchDataView.isHidden = true
        isSearch = false
    }
    
    
    
    @IBAction func searchTxtFldAction(_ sender: UITextField) {
        
        if searchTxtFld.text != ""{
            self.searchDataArray = self.ChoirRehearsalDataArray.filter{
                ($0.name).range(of: self.searchTxtFld.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            }
            dataTbView.reloadData()
        }else{
            searchDataArray = ChoirRehearsalDataArray
            dataTbView.reloadData()
        }
        dataTbView.reloadData()
    }
    
    func categoryDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.DetailsByCat
            print(signInUrl)
            let parms : [String:Any] = ["c_id" : "2" , "search" : ""]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.ChoirRehearsalDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [[String:Any]]{
                        for obj in allData{
                            self.ChoirRehearsalDataArray.append(ChoirRehearsalData(image: obj["image"] as? String ?? "", details: obj["description"] as? String ?? "", name: obj["title"] as? String ?? "", date: "21Dec", link: obj["link"] as? String ?? ""))
                        }
                    }
                    self.searchDataArray = self.ChoirRehearsalDataArray
                    self.dataTbView.reloadData()
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


class DataTbViewCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ChoirRehearsal : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTbViewCell", for: indexPath) as! DataTbViewCell
        cell.titleLbl.text = searchDataArray[indexPath.row].name
        cell.showImage.image = UIImage(named: searchDataArray[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
}

struct ChoirRehearsalData {
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
