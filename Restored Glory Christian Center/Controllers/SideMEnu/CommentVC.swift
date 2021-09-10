//
//  CommentVC.swift
//  Restored Glory Christian Center
//
//  Created by MyMac on 9/10/21.
//
import UIKit
import SDWebImage
import Foundation

class CommentVC : UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var txtComment: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblComment: UITableView!
    
    var postID = String()
    var commentArray = [CommentData]()
    
    //------------------------------------------------------
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    // MARK: Custome
    
    func addComment(){
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        IJProgressView.shared.showProgressView()
        let CategoryData = Constant.shared.baseUrl + Constant.shared.addComment
        let parms : [String:Any] = ["comment_by":id,"link_id":postID,"comment":txtComment.text ?? ""]
        AFWrapperClass.requestPOSTURL(CategoryData, params: parms, success: { (response) in
            IJProgressView.shared.hideProgressView()
            print(response)
            let status = response["status"] as? Int ?? 0
            print(status)
            let message = response["message"] as? String ?? ""
            if status == 1{
                self.commentsList()
            }else{
                alert(Constant.shared.appTitle, message: message, view: self)
            }
            self.tblComment.reloadData()
        })
        { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
        }
    }
    
    func commentsList(){
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        IJProgressView.shared.showProgressView()
        let CategoryData = Constant.shared.baseUrl + Constant.shared.allComment
        let parms : [String:Any] = ["user_id":id, "link_id": postID]
        AFWrapperClass.requestPOSTURL(CategoryData, params: parms, success: { (response) in
            print(response)
            IJProgressView.shared.hideProgressView()
            let status = response["status"] as? Int ?? 0
            let img = response["photo"] as? String ?? ""
            self.imgProfile.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "img1"))
            print(status)
            self.commentArray.removeAll()
            if status == 1{
                for obj in response["comment_data"] as? [[String:Any]] ?? [[:]]{
                        print(obj)
                    self.commentArray.append(CommentData(comment: obj["comment"] as? String ?? "", commentID: obj["comment_id"] as? String ?? "", postID: obj["link_id"] as? String ?? "", userID: obj["user_id"] as? String ?? "", date: obj["created_at"] as? String ?? "", name: obj["first_name"] as? String ?? "", image: obj["photo"] as? String ?? ""))
                    }
                self.tblComment.reloadData()
                DispatchQueue.main.async {
                    let index = IndexPath(row: self.commentArray.count-1, section: 0)
                    self.tblComment.scrollToRow(at: index, at: .bottom, animated: true)
                }
            }else{
            }
            self.lblNoData.isHidden = self.commentArray.count == 0 ? false : true
            self.tblComment.reloadData()
        })
        { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
        }
    }
    
    func compareDate(date1:Date, date2:Date) -> Bool {
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Actions
    
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnPost(_ sender: Any) {
        let trimmedString = txtComment.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if trimmedString != ""{
            txtComment.resignFirstResponder()
            self.addComment()
            txtComment.text = ""
//            self.txtComment.constant = 45
        }
    }
    
    //------------------------------------------------------
    
    //MARK: Table view datasuorce , delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTBCell", for: indexPath) as! CommentTBCell
        cell.btnReport.tag = indexPath.row
        cell.btnReport.addTarget(self, action: #selector(gotoReportVC(sender:)), for: .touchUpInside)
        cell.lblComment.text = commentArray[indexPath.row].comment
        cell.lblName.text = commentArray[indexPath.row].name
        let dateValue = commentArray[indexPath.row].date
        let dateVal = NumberFormatter().number(from: dateValue)?.doubleValue ?? 0.0
        cell.lblDate.text = convertTimeStampToDate(dateVal: dateVal)
        cell.imgProfile.sd_setShowActivityIndicatorView(true)
        if #available(iOS 13.0, *) {
            cell.imgProfile.sd_setIndicatorStyle(.large)
        } else {
        }
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if id as? String ?? "" == commentArray[indexPath.row].userID {
            cell.btnReport.isHidden = true
            cell.imgBlok.isHidden = true
        } else {
            cell.btnReport.isHidden = false
            cell.imgBlok.isHidden = false
        }
        cell.imgProfile.sd_setImage(with: URL(string: commentArray[indexPath.row].image), placeholderImage: UIImage(named: ""), options: SDWebImageOptions.continueInBackground, completed: nil)
        let unixtimeInterval = commentArray[indexPath.row].date
        let date = Date(timeIntervalSince1970:  unixtimeInterval.doubleValue)
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.locale = NSLocale.current
        if compareDate(date1: now, date2: date){
            dateFormatter.dateFormat = "hh:mm a"
        }else{
            dateFormatter.dateFormat = "dd MMM yyyy, hh:mm a"
        }
            
        return cell
    }
    
    @objc func gotoReportVC(sender : UIButton) {
        let vc = ReportVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        commentsList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        commentsList()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

class CommentTBCell: UITableViewCell {
    
    @IBOutlet weak var imgBlok: UIImageView!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
}

struct CommentData {
    
    var comment : String
    var commentID : String
    var postID : String
    var userID : String
    var date : String
    var name : String
    var image : String
    
    init(comment: String, commentID: String, postID: String, userID: String, date: String,name : String , image : String) {
        self.comment = comment
        self.commentID = commentID
        self.postID = postID
        self.userID = userID
        self.date = date
        self.name = name
        self.image = image
    }
}
