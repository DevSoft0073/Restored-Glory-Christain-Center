//
//  NotificationsVC.swift
//  Restored Glory Christian Center
//
//  Created by Vivek Dharmani on 19/05/21.
//

import UIKit

class NotificationsVC: UIViewController {

    @IBOutlet weak var notificationsTableView:
        UITableView!
    var message = String()
    var timeArray = [String]()
    var notificationsTBDataArray = [NotificationsTBData]()
    var searchDataArray = [NotificationsTBData]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
        notificationsTableView.reloadData()
        notificaionDetials()

    }
    


    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func notificaionDetials() {
        if Reachability.isConnectedToNetwork() == true{
            print("Internet Connection Ok")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let notifyUrl = Constant.shared.baseUrl + Constant.shared.allPushData
            print(notifyUrl)
            let parms : [String:Any] = ["user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(notifyUrl, params: parms, success: {(response) in
                print(response)
                IJProgressView.shared.hideProgressView()
                self.notificationsTBDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let getData = response["data"] as? [[String:Any]]{
                        for obj in getData{

                            self.notificationsTBDataArray.append(NotificationsTBData(image: obj["image"] as? String ?? "", title: obj["title"] as? String ?? "", content: obj["description"] as? String ?? "", time: "\(obj["notification_date "] as? String ?? "")" + "\("ago")"))
                            self.timeArray.append(obj["notification_date"] as? String ?? "")
                        }
                    }
                    self.searchDataArray = self.notificationsTBDataArray
                    self.notificationsTableView.reloadData()
                }else {
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
                
            }) {(error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet Connection Failed")
            alert(Constant.shared.appTitle, message: "Check Internet connection", view: self)
        }
    }
    func getDateFormat(dateString: String, dateVal: String)->Date{
        if dateVal == ""{
            return Date()
        }else{
            let formatter = DateFormatter()
            formatter.dateFormat = dateString
           formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter.date(from: dateVal) ?? Date()
        }
    }
    
}
class notificationsTableView : UITableViewCell{
    
    @IBOutlet weak var notifyImg: UIImageView!
    @IBOutlet weak var notifyTitleLbl: UILabel!
    @IBOutlet weak var notifyContentLbl: UILabel!
    @IBOutlet weak var notifyTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
  
}
extension NotificationsVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsTBDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationsTableView", for: indexPath) as! notificationsTableView
        cell.notifyImg.image = UIImage(named: "icon")
        cell.notifyTitleLbl.text = notificationsTBDataArray[indexPath.row].title
        cell.notifyContentLbl.text = notificationsTBDataArray[indexPath.row].content
        cell.notifyTimeLbl.text = "\(timeArray[indexPath.row]) Ago"
        cell.notifyImg.setRounded()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

struct  NotificationsTBData {
    var image : String
    var title : String
    var content : String
    var time : String
    init(image : String , title : String , content : String , time : String) {
        self.image = image
        self.title = title
        self.content = content
        self.time = time
    }
    
}

