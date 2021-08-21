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
        popUpDetails()
//        let attributedString = NSMutableAttributedString(string: "Want to learn ios get it will be best for you")
    
    }
    
//    var expandedCells = Set<Int>()
    @IBAction func dropDownButton(_ sender: Any) {
        
        let transition:CATransition = CATransition()
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.reveal
//        transition.subtype = CATransitionSubtype.fromBottom
//        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func readMoreBtn(_ sender: Any) {
//        let vc = DetailsDataVC.instantiate(fromAppStoryboard: .Main)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    func popUpDetails(){
        if Reachability.isConnectedToNetwork() == true{
            print("Internet Connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let  signUrl = Constant.shared.baseUrl + Constant.shared.DetailsByCat
            let  parms : [String:Any] = ["c_id" : "7" , "search" : ""]
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
                            self.popListingTBDataArray.append(PopListingTBData(image: obj["image"] as? String ?? "", name: obj["title"] as? String ?? "", time: obj["servercreated_at"] as? String ?? "", content: obj["description"] as? String ?? "", link: obj["link"] as? String ?? ""))
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

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var readMoreTextView: UITextView!
//    @IBOutlet weak var readMoreLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
     
       
    }
    //Wait for youtube player to to get ready or proceed if it is ready.

//    override func prepareForReuse() {
//        super.prepareForReuse()
//
//        readMoreTextView.onSizeChange = { _ in }
//        readMoreTextView.shouldTrim = true
//    }
    
    
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
        //        cell.contentLbl.text = popListingTBDataArray[indexPath.row].content
        cell.readMoreTextView.text = popListingTBDataArray[indexPath.row].content
        
        //        var bhikmangaTextlbl:UITextView?
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
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool
              {
        print("readmore")
                  return true
              }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
        
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell:PopUpListingTableView = tableView.cellForRow(at: indexPath) as! PopUpListingTableView
        if let theURL = URL(string: popListingTBDataArray[indexPath.row].link){
           let lastPath = theURL.lastPathComponent
            IJProgressView.shared.showProgressView()
        otherPlayer.load(withVideoId: "\(lastPath)",playerVars: ["playsinline" : 0])
        
        }
//        UIApplication.shared.open(URL(string: popListingTBDataArray[0].link)!, options: [:], completionHandler: nil)
    }
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error)
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        IJProgressView.shared.hideProgressView()
        playerView.playVideo()
    }
    
   
}
struct PopListingTBData {
    var image : String
    var name : String
    var time : String
    var content : String
    var link : String
    init(image : String ,name :  String
         , time : String , content : String, link : String) {
        self.image = image
        self.name = name
        self.time = time
        self.content = content
        self.link = link
    }
}
//extension UILabel {
//
//    func addTrailing(with trailingText: String, moreText: String) {
//        let readMoreText: String = trailingText + moreText
//
//        let lengthForVisibleString: Int = self.visibleTextLength
//        let mutableString: String = self.text!
//        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
//        let readMoreLength: Int = (readMoreText.count)
//        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
//        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font])
////        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
////        answerAttributed.append(readMoreAttributed)
//        self.attributedText = answerAttributed
//    }
//
//    var visibleTextLength: Int {
//        let font: UIFont = self.font
//        let mode: NSLineBreakMode = self.lineBreakMode
//        let labelWidth: CGFloat = self.frame.size.width
//        let labelHeight: CGFloat = self.frame.size.height
//        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
//
//        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
//        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
//        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
//
//        if boundingRect.size.height > labelHeight {
//            var index: Int = 0
//            var prev: Int = 0
//            let characterSet = CharacterSet.whitespacesAndNewlines
//            repeat {
//                prev = index
//                if mode == NSLineBreakMode.byCharWrapping {
//                    index += 1
//                } else {
//                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
//                }
//            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
//            return prev
//        }
//        return self.text!.count
//    }
//}


