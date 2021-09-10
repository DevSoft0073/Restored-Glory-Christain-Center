//
//  ReportVC.swift
//  Restored Glory Christian Center
//
//  Created by MyMac on 9/10/21.
//
import UIKit
import Foundation

class ReportVC : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tblReport: UITableView!
    
    var resnArray = [ReportData]()
    var message = String()
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
    
    func categoryListing() {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let signInUrl = Constant.shared.baseUrl + Constant.shared.resnData
            let parms : [String:Any] = ["userID" : id , "search" : ""]
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
                self.resnArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    for obj in response["data"] as? [[String:Any]] ?? [[:]] {
                        print(obj)
                        self.resnArray.append(ReportData(resnID: obj["reasonId"] as? String ?? "", resnName: obj["reportReasons"] as? String ?? "", selected: false))
                    }
                    self.tblReport.reloadData()
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
    
    func addReport() {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let signInUrl = Constant.shared.baseUrl + Constant.shared.addReport
            let selectedElement = resnArray.filter({$0.selected == true})
            let parms : [String:Any] = ["reasonId":selectedElement[0].resnID,"reportedId":"1","reportType":"2","reportedBy":id]
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
                self.resnArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    DisplayAlertManager.shared.displayAlert(animated: true, message: self.message, okTitle: "Ok") {
                        self.navigationController?.popViewController(animated: true)
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


    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmit(_ sender: Any) {
        let selectedElement = resnArray.filter({$0.selected == true})
        if selectedElement.count == 0{
            alert(Constant.shared.appTitle, message: "Please select your report reason", view: self)
        }else{
            addReport()
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resnArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell", for: indexPath) as! ReportCell
        cell.lblName.text = resnArray[indexPath.row].resnName
        cell.imgSelected.image = resnArray[indexPath.row].selected == true ? #imageLiteral(resourceName: "selected") : #imageLiteral(resourceName: "unselected")
        return cell
    }
    
    //------------------------------------------------------
    
    //MARK: TableView delegate datasource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.resnArray = self.resnArray.map({ obj in
            var changeObj = obj
            changeObj.selected = false
            return changeObj
        })
        self.resnArray[indexPath.row].selected = true
        self.tblReport.reloadData()
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblReport.delegate = self
        tblReport.dataSource = self
        tblReport.separatorStyle = .none
        tblReport.separatorColor = .clear
        
        categoryListing()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

class ReportCell: UITableViewCell {
    
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

struct ReportData {
    var resnID : String
    var resnName : String
    var selected : Bool
    
    init(resnID : String,resnName : String,selected : Bool) {
        self.resnID = resnID
        self.resnName = resnName
        self.selected = selected
    }
}
