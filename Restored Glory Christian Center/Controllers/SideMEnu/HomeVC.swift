//
//  HomeVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController , UITextFieldDelegate{
    
    @IBOutlet weak var addLinkButton: UIButton!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var showAllDataTbView: UITableView!
    var allDataArray = [AllData]()
    var searchDataArray = [SearchData]()
    var isSearch = false
    var message = String()
    var ckeckRole = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showAllDataTbView.reloadData()
        categoryListing()
        //        searchDataArray.append(SearchData(title: "Live Sirmon", image: "youth"))
        //        searchDataArray.append(SearchData(title: "Live Sirmon", image: "youth"))
        
        searchView.isHidden = true
        showAllDataTbView.separatorStyle = .none
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.value(forKey: "checkRole") as? String ?? "" == "0" {
            
            addLinkButton.isHidden = true
            
        }else{
            
            addLinkButton.isHidden = false
            
        }
    }
    @IBAction func addLinkButton(_ sender: Any) {
        
        
        let vc = AddLinkVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchView.isHidden = true
        isSearch = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchView.isHidden = true
        isSearch = false
    }
    
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        if isSearch == false {
            searchView.isHidden = true
            isSearch = true
        }else{
            searchView.isHidden = false
            isSearch = false
        }
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchData(word: searchTxtFld.text ?? "")
        searchTxtFld.resignFirstResponder()
        return true
    }
    
    func searchData( word: String)  {
        searchDataArray.removeAll()
//        let filterArray = allDataArray.
        for item in allDataArray[0].title {
            if item.lowercased().contains(word.lowercased()) {
                searchDataArray[0].title.append(item)
            }
            print(searchDataArray)
            DispatchQueue.main.async {
                self.showAllDataTbView.reloadData()
            }
        }
    }
    
    
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
//
//        let searchText  = searchTxtFld.text ?? ""
//        if searchText.count >= 3 {
//            showAllDataTbView.isHidden = false
//
//            searchDataArray = allDataArray.filter({ (result) -> Bool in
//                return result.range(of: searchText, options: .caseInsensitive) != nil
//            })
//
//            print(searchDataArray)   // I got filtered data here but how to show this data into the tableview
//            showAllDataTbView.reloadData()
//        }
//        else{
//            searchDataArray = []
//        }
//        return true
//    }
    
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    
    func categoryListing() {
        
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.CategoryType
            print(signInUrl)
            let parms : [String:Any] = ["userID" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.allDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["category_details"] as? [[String:Any]]{
                        for obj in allData{
                            self.allDataArray.append(AllData(title: obj["name"] as? String ?? "", image: obj[""] as? String ?? "", catId: obj["c_id"] as? String ?? ""))
                        }
                    }
                    self.showAllDataTbView.reloadData()
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

class ShowAllDataTbViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var images: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}

extension HomeVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch == true {
            return searchDataArray.count
        }else {
            return allDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAllDataTbViewCell", for: indexPath) as! ShowAllDataTbViewCell
        cell.titleLbl.text = allDataArray[indexPath.row].title
        cell.images.image = UIImage(named: allDataArray[indexPath.row].image)
        cell.images.sd_setImage(with: URL(string:allDataArray[indexPath.row].image), placeholderImage: UIImage(named: "youth"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsVC.instantiate(fromAppStoryboard: .Main)
        vc.catId = allDataArray[indexPath.row].catId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}

struct AllData {
    var title : String
    var image : String
    var catId : String
    
    init(title : String , image : String , catId : String) {
        self.title = title
        self.image = image
        self.catId = catId
        
    }
}

struct SearchData {
    var title : String
    var image : String
    var catId : String
    
    init(title : String , image : String , catId : String) {
        self.title = title
        self.image = image
        self.catId = catId
    }
}
