//
//  PopUpListingVC.swift
//  Restored Glory Christian Center
//
//  Created by Vivek Dharmani on 20/05/21.
//

import UIKit
import ReadMoreTextView
import youtube_ios_player_helper

class PopUpListingVC: UIViewController,UITextViewDelegate, YTPlayerViewDelegate {
    
    @IBOutlet weak var PopUpListingTableView: UITableView!
    
    @IBOutlet weak var otherPlayer: YTPlayerView!
    var message = String()
    var popListingTBDataArray = [PopListingTBData]()
    var searchDataArray = [PopListingTBData]()
    var catId = String()
    var catName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        otherPlayer.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        popUpDetails()
    }
    
    @IBAction func dropDownButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func readMoreBtn(_ sender: Any) {
    }
    
    func popUpDetails(){
        if Reachability.isConnectedToNetwork() == true{
            print("Internet Connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let  signUrl = Constant.shared.baseUrl + Constant.shared.DetailsByCat
            let  parms : [String:Any] = ["c_id" : "7" , "search" : "", "user_id" : id]
            print("parms")
            AFWrapperClass.requestPOSTURL(signUrl, params: parms, success: {(response) in
                print(response)
                IJProgressView.shared.hideProgressView()
                self.popListingTBDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response ["data"] as? [[String:Any]]{
                        for obj in allData {
                            self.popListingTBDataArray.append(PopListingTBData(image: obj["image"] as? String ?? "", name: obj["title"] as? String ?? "", time: obj["servercreated_at"] as? String ?? "", content: obj["description"] as? String ?? "", link: obj["link"] as? String ?? "", id: obj["link_id"] as? String ?? "",likeCount: obj["total_likes"] as? String ?? "",commentCount: obj["total_comments"] as? String ?? "", isLike: obj["isLike"] as? String ?? ""))
                        }
                    }
                    self.searchDataArray = self.popListingTBDataArray
                    self.PopUpListingTableView.reloadData()
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }){(error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
                
            }
        }else {
            print("Internet Connection Failed")
            alert(Constant.shared.appTitle, message: "Check Internet Connection", view: self)
        }
    }
    
    
}
class PopUpListingTableView : UITableViewCell {
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblLikes: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnlike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var readMoreTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
}
extension PopUpListingVC : UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popListingTBDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopUpListingTableView", for: indexPath) as! PopUpListingTableView
        
        cell.mainImg.sd_setImage(with: URL(string: popListingTBDataArray [indexPath.row].image), placeholderImage: UIImage(named: "pl"))
        cell.nameLbl.text = popListingTBDataArray[indexPath.row].name
        cell.timeLbl.text = popListingTBDataArray[indexPath.row].time
        cell.readMoreTextView.text = popListingTBDataArray[indexPath.row].content
        cell.lblLikes.text = popListingTBDataArray[indexPath.row].likeCount
        cell.lblComment.text = popListingTBDataArray[indexPath.row].commentCount
        cell.btnComment.tag = indexPath.row
        
        if popListingTBDataArray[indexPath.row].isLike == "1" {
            cell.imgLike.image = UIImage(named: "like1")
        } else if popListingTBDataArray[indexPath.row].isLike == "0" {
            cell.imgLike.image = UIImage(named: "like")
        } else if popListingTBDataArray[indexPath.row].isLike == "" {
            cell.imgLike.image = UIImage(named: "like")
        }
        
        cell.btnComment.addTarget(self, action: #selector(btnComment(sender:)), for: .touchUpInside)
        cell.btnShare.tag = indexPath.row
//        cell.btnShare.addTarget(self, action: #selector(shareBtnAction(sender:)), for: .touchUpInside)
        cell.btnlike.tag = indexPath.row
        cell.btnlike.addTarget(self, action: #selector(likeUnlikeBtnAction(sender:)), for: .touchUpInside)
        if cell.readMoreTextView!.text!.count >= 120
        {
            cell.readMoreTextView.delegate = self
            var abc : String =  (cell.readMoreTextView!.text! as NSString).substring(with: NSRange(location: 0, length: 120))
            abc += " ...ReadMore"
            cell.readMoreTextView!.text = abc
            var attribs = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)]
            var attributedString: NSMutableAttributedString = NSMutableAttributedString(string: abc, attributes: attribs)
            attributedString.addAttribute(NSAttributedString.Key.link, value: "...ReadMore", range: NSRange(location: 120, length: 11))
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 120, length: 11))
            cell.readMoreTextView!.attributedText = attributedString
            
        }
        return cell
    }
    
    @objc func likeUnlikeBtnAction(sender : UIButton) {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        IJProgressView.shared.showProgressView()
        let CategoryData = Constant.shared.baseUrl + Constant.shared.likeUnlike
        let parms : [String:Any] = ["user_id":id, "link_id": popListingTBDataArray[sender.tag].id]
        AFWrapperClass.requestPOSTURL(CategoryData, params: parms, success: { (response) in
            print(response)
            IJProgressView.shared.hideProgressView()
            let status = response["status"] as? Int ?? 0
            let msg = response["message"] as? String ?? ""
            print(status)
            if status == 1{
                self.popListingTBDataArray[sender.tag].isLike = self.popListingTBDataArray[sender.tag].isLike == "0" ? "1" : "0"
                var likeCount = NumberFormatter().number(from: self.popListingTBDataArray[sender.tag].likeCount)?.intValue ?? 0
                likeCount =  self.popListingTBDataArray[sender.tag].isLike == "1" ? likeCount+1 : likeCount-1
                self.popListingTBDataArray[sender.tag].isLike = "\(likeCount)"
                self.popUpDetails()
                
            }else{
                alert(Constant.shared.appTitle, message: msg, view: self)
            }
        })
        { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
        }
    }
    
    @objc func btnComment(sender : UIButton) {
        let vc = CommentVC.instantiate(fromAppStoryboard: .Main)
        vc.postID = popListingTBDataArray[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool
    {
        print("readmore")
        return true
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        otherPlayer.isHidden = false
        //     //   if let theURL = URL(string: popListingTBDataArray[indexPath.row].link){
        //        if popListingTBDataArray[indexPath.row].link.contains("v="){
        //            let lastPath = getYoutubeId(youtubeUrl: popListingTBDataArray[indexPath.row].link)
        //            IJProgressView.shared.showProgressView()
        //            otherPlayer.load(withVideoId: "\(lastPath ?? "")",playerVars: ["playsinline" : 0])
        //        }else{
        //            if let theURL = URL(string: popListingTBDataArray[indexPath.row].link){
        //                let lastPath = theURL.lastPathComponent
        //                IJProgressView.shared.showProgressView()
        //                otherPlayer.load(withVideoId: "\(lastPath)",playerVars: ["playsinline" : 0])
        //            }
        //        }
    }
    
    func getYoutubeId(youtubeUrl: String) -> String? {
        return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error)
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        IJProgressView.shared.hideProgressView()
        playerView.playVideo()
    }
    
//    @objc func shareBtnAction(sender : UIButton) {
//        IJProgressView.shared.showProgressView()
//        AFWrapperClass.createContentDeepLink(title: Constant.shared.appTitle, type: "Post", OtherId: popListingTBDataArray[sender.tag].id, description: "Hey, look at this post.", image: nil, link: popListingTBDataArray[sender.tag].link == "" ? popListingTBDataArray[sender.tag].image : popListingTBDataArray[sender.tag].link) { urlStr in
//            IJProgressView.shared.hideProgressView()
//            if let url = URL(string: urlStr ?? "") {
//                print(urlStr)
//                let objectsToShare = ["Hey, look at this post.", self.popListingTBDataArray[sender.tag].image == "" ? self.popListingTBDataArray[sender.tag].link : self.popListingTBDataArray[sender.tag].image] as [Any]
//                AFWrapperClass.presentShare(objectsToShare: objectsToShare, vc: self)
//            }
//        }
//    }
}

struct PopListingTBData {
    var image : String
    var name : String
    var time : String
    var content : String
    var link : String
    var id : String
    var likeCount : String
    var commentCount : String
    var isLike: String
    init(image : String ,name :  String
         , time : String , content : String, link : String,id : String,likeCount : String,commentCount : String, isLike: String) {
        self.image = image
        self.name = name
        self.time = time
        self.content = content
        self.link = link
        self.id = id
        self.likeCount = likeCount
        self.commentCount = commentCount
        self.isLike = isLike
    }
}

