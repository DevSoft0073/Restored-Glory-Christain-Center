//
//  HomeScreenVC.swift
//  Restored Glory Christian Center
//
//  Created by Vivek Dharmani on 18/05/21.
//

import UIKit
import SwiftGifOrigin
import SDWebImage
import youtube_ios_player_helper

class HomeScreenVC: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var playVIdeo: YTPlayerView!
    @IBOutlet weak var btnLive: UIButton!
    @IBOutlet weak var btnGlory: UIButton!
    @IBOutlet weak var btnTeen: UIButton!
    @IBOutlet weak var btnWomen: UIButton!
    @IBOutlet weak var btnMen: UIButton!
    @IBOutlet weak var tblGlory: UICollectionView!
    @IBOutlet weak var tblTeens: UICollectionView!
    @IBOutlet weak var tblWomens: UICollectionView!
    @IBOutlet weak var tblMens: UICollectionView!
    @IBOutlet weak var choirCollectionView: UICollectionView!
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var mainButton: UIButton!
    @IBOutlet weak var choirSeeButton: UIButton!
    @IBOutlet weak var upcomingSeeButton: UIButton!
    @IBOutlet weak var bibleSeeButton: UIButton!
    @IBOutlet weak var choirCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var liveIcon: UIImageView!
    @IBOutlet weak var studyCollectionView: UICollectionView!
    @IBOutlet weak var noDataChoirLbl: UILabel!
    @IBOutlet weak var noDataStudyLbl: UILabel!
    @IBOutlet weak var noDataUpcomingLbl: UILabel!
    
    @IBOutlet weak var lblMens: UILabel!
    @IBOutlet weak var lblWomens: UILabel!
    @IBOutlet weak var lblTeens: UILabel!
    @IBOutlet weak var lblGlory: UILabel!
    
    @IBOutlet weak var upcommingView: UIView!
    @IBOutlet weak var choirView: UIView!
    @IBOutlet weak var gloryView: UIView!
    @IBOutlet weak var bibleView: UIView!
    @IBOutlet weak var womensView: UIView!
    @IBOutlet weak var mensView: UIView!
    @IBOutlet weak var teensView: UIView!
    
    var message = String()
    var ChoirCLDataArray = [ChoirCLData]()
    var studyCLDataArray = [StudyCLData]()
    var upcomingDataArray = [UpcomingData]()
    var bibleDataArray = [BibleData]()
    var mensDataArray = [MensData]()
    var womensDataArray = [WomenData]()
    var teenDataArray = [TeenData]()
    var gloryDataArray = [GloryData]()
    var AllHomeArray = [AllHome]()
    var imageDataArray = [String]()
    var catId = String()
    var catName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
        upcomingTableView.separatorStyle = .none
        //        loadGif()
        self.noDataStudyLbl.isHidden = true
        self.noDataChoirLbl.isHidden = true
        self.noDataUpcomingLbl.isHidden = true
        playVIdeo.delegate = self
        homeDetails()
        
    }
    
    @IBAction func sideMenuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func notificationButton(_ sender: Any) {
        let vc = NotificationsVC.instantiate(fromAppStoryboard: .Main)
        (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
    }
    
    @IBAction func mainBttn(_ sender: Any) {
        
        if let theURL = URL(string: bibleDataArray[0].url){
           let lastPath = theURL.lastPathComponent
            IJProgressView.shared.showProgressView()
            playVIdeo.load(withVideoId: "\(lastPath)",playerVars: ["playsinline" : 0])

        }
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error)
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        IJProgressView.shared.hideProgressView()
        playerView.playVideo()
    }
    
    
    
    @IBAction func btnLiveSteream(_ sender: Any) {
        let vc = PopUpListingVC.instantiate(fromAppStoryboard: .Main)
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//        transition.type = CATransitionType.push
//        transition.subtype = CATransitionSubtype.fromTop
//        self.navigationController?.view.layer.add(transition, forKey: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    
    @IBAction func choirSeeButton(_ sender: Any) {
        if ChoirCLDataArray.count <= 0{
            choirSeeButton.isUserInteractionEnabled = false
        }else{
            choirSeeButton.isUserInteractionEnabled = true
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "2"
            vc.titleName = "Choir Reharsal"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func upcomingSeeButton(_ sender: Any) {
        if upcomingDataArray.count <= 0 {
            upcomingSeeButton.isUserInteractionEnabled = false
        }else{
            upcomingSeeButton.isUserInteractionEnabled = true
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "10"
            vc.titleName = "Upcoming Events"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func studySeeButton(_ sender: Any) {
        if studyCLDataArray.count <= 0 {
            bibleSeeButton.isUserInteractionEnabled = false
        }else {
            bibleSeeButton.isUserInteractionEnabled = true
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "9"
            vc.titleName = "Bible Study"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnMens(_ sender: Any) {
        if mensDataArray.count <= 0 {
            btnMen.isUserInteractionEnabled = false
        }else{
            btnMen.isUserInteractionEnabled = true
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "4"
            vc.titleName = "Mens Ministry"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnWomes(_ sender: Any) {
        if womensDataArray.count <= 0 {
            btnWomen.isUserInteractionEnabled = false
        }else{
            btnWomen.isUserInteractionEnabled = true
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "3"
            vc.titleName = "Womens Ministry"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnTeens(_ sender: Any) {
        if teenDataArray.count <= 0 {
            btnTeen.isUserInteractionEnabled = false
        }else{
            btnTeen.isUserInteractionEnabled = true
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "5"
            vc.titleName = "Teens Ministry"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnGlory(_ sender: Any) {
        if gloryDataArray.count <= 0 {
            btnGlory.isUserInteractionEnabled = false
        }else{
            btnGlory.isUserInteractionEnabled = true
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "6"
            vc.titleName = "Glory Kids"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func homeDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let homeUrl = Constant.shared.baseUrl + Constant.shared.homeData
            print(homeUrl)
            let parms : [String:Any] = ["user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(homeUrl, params: parms, success: { [self](response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response ["status"] as? Int
                self.ChoirCLDataArray.removeAll()
                self.bibleDataArray.removeAll()
                self.upcomingDataArray.removeAll()
                self.studyCLDataArray.removeAll()
                self.mensDataArray.removeAll()
                self.womensDataArray.removeAll()
                self.teenDataArray.removeAll()
                self.gloryDataArray.removeAll()
                if status == 1 {
                    if let allData =  response["category_details"] as? [[String:Any]] {
                        for obj in allData{
                            self.catId = ""
                            print(obj)
                            self.catId.append(obj["c_id"] as! String)
                            
                            if let getData = obj["addedlinks"] as? [[String:Any]]{
                                print(getData)
                                
                                for i in getData {
                                    if self.catId == "10" {
                                        print(i)
                                        self.upcomingDataArray.append(UpcomingData(image: i["image"] as? String ?? "", title: i["title"] as? String ?? "", detail: i["description"] as? String ?? ""))
                                        
                                    }
                                    
                                    else if self.catId  == "9" {
                                        print(i)
                                        self.studyCLDataArray.append(StudyCLData(image: i["image"] as? String ?? "", link: i["link"] as? String ?? "", title: i["title"] as? String ?? ""))
                                    }
                                    else if self.catId == "7"{
                                        print(i)
                                        self.mainImg.sd_setImage(with: URL(string: i["image"] as? String ?? ""), placeholderImage: UIImage(named: "pl"), options: SDWebImageOptions.continueInBackground, completed: nil)
                                        self.liveIcon.loadGif(name: "tower")
                                        self.mainImg.contentMode = .scaleAspectFill
                                        self.bibleDataArray.append(BibleData(mimage: i["image"] as? String ?? "", gimage: i["image"] as? String ?? "", url: i["link"] as? String ?? ""))
                                        
                                    }
                                    else if self.catId == "2" {
                                        print(i)
                                        
                                        self.ChoirCLDataArray.append(ChoirCLData(image: i["image"] as? String ?? "", name: i["title"] as? String ?? ""))
                                        
                                    } else if self.catId == "4" {
                                        
                                        self.mensDataArray.append(MensData(image: i["image"] as? String ?? "", name: i["title"] as? String ?? ""))
                                        
                                    } else if self.catId == "3" {
                                        
                                        self.womensDataArray.append(WomenData(image: i["image"] as? String ?? "", name: i["title"] as? String ?? ""))
                                        
                                    } else if self.catId == "5" {
                                        
                                        self.teenDataArray.append(TeenData(image: i["image"] as? String ?? "", name: i["title"] as? String ?? ""))
                                        
                                    } else if self.catId == "6" {
                                        
                                        self.gloryDataArray.append(GloryData(image: i["image"] as? String ?? "", name: i["title"] as? String ?? ""))
                                        
                                    }
                                }
                            }
                        }
                        
                        self.choirCollectionView.reloadData()
                        self.studyCollectionView.reloadData()
                        self.upcomingTableView.reloadData()
                        
                        self.tblMens.reloadData()
                        self.tblWomens.reloadData()
                        self.tblTeens.reloadData()
                        self.tblGlory.reloadData()
                        
                        self.noDataChoirLbl.isHidden = self.ChoirCLDataArray.count == 0 ? false : true
                        self.noDataUpcomingLbl.isHidden = self.upcomingDataArray.count == 0 ? false : true
                        self.noDataStudyLbl.isHidden = self.studyCLDataArray.count == 0 ? false : true
                        self.lblMens.isHidden = self.mensDataArray.count == 0 ? false : true
                        self.lblWomens.isHidden = self.womensDataArray.count == 0 ? false : true
                        self.lblTeens.isHidden = self.teenDataArray.count == 0 ? false : true
                        self.lblGlory.isHidden = self.gloryDataArray.count == 0 ? false : true
                        
                        if ChoirCLDataArray.count <= 3 {
                            choirView.isHidden = true
                        }else{
                            choirView.isHidden = false
                        }
                        
                        if upcomingDataArray.count < 3 {
                            upcommingView.isHidden = true
                        }else{
                            upcommingView.isHidden = false
                        }
                        
                        if studyCLDataArray.count <= 3 {
                            bibleView.isHidden = true
                        }else{
                            bibleView.isHidden = false
                        }
                        
                        if mensDataArray.count <= 3 {
                            mensView.isHidden = true
                        }else{
                            mensView.isHidden = false
                        }
                        
                        if womensDataArray.count <= 3 {
                            womensView.isHidden = true
                        }else{
                            womensView.isHidden = false
                        }
                        
                        if teenDataArray.count <= 3 {
                            teensView.isHidden = true
                        }else{
                            teensView.isHidden = false
                        }
                        
                        if gloryDataArray.count <= 3 {
                            gloryView.isHidden = true
                        }else{
                            gloryView.isHidden = false
                        }
                        
                    }else {
                        IJProgressView.shared.hideProgressView()
                    }
                }
            }){(error) in
                IJProgressView.shared.hideProgressView()
//                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
                
            }
        }else {
            print("Internet Connection Failed")
            alert(Constant.shared.appTitle, message: "Check Internet Connection", view: self)
        }
    }
}
class choirCollectionView : UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
class studyCollectionView : UICollectionViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
class upcomingTableView : UITableViewCell{
    
    
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var upcomingImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


class MensCell: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var showImg: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class WomenMinistry: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var showImg: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TennsMinistry: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var showImg: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

class GloryKids: UICollectionViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var showImg: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}





extension HomeScreenVC : UICollectionViewDelegate , UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == choirCollectionView{
            if ChoirCLDataArray.count <= 0 {
                self.choirCollectionView.setEmptyMessage("")
            }else {
                self.choirCollectionView.restore()
            }
            return ChoirCLDataArray.count
        }
        
        if collectionView == tblMens{
            if mensDataArray.count <= 0 {
                self.tblMens.setEmptyMessage("")
            }else {
                self.tblMens.restore()
            }
            return mensDataArray.count
        }

        if collectionView == tblWomens{
            if womensDataArray.count <= 0 {
                self.tblWomens.setEmptyMessage("")
            }else {
                self.tblWomens.restore()
            }
            return womensDataArray.count
        }

        if collectionView == tblTeens{
            if teenDataArray.count <= 0 {
                self.tblTeens.setEmptyMessage("")
            }else {
                self.tblTeens.restore()
            }
            return teenDataArray.count
        }

        if collectionView == tblGlory{
            if gloryDataArray.count <= 0 {
                self.tblGlory.setEmptyMessage("")
            }else {
                self.tblGlory.restore()
            }
            return gloryDataArray.count
        }
        
        if studyCLDataArray.count <= 0 {
            self.studyCollectionView.setEmptyMessage("No Data")
        }else {
            self.studyCollectionView.restore()
        }
        
        return studyCLDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == choirCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "choirCollectionView", for: indexPath) as! choirCollectionView
            if ChoirCLDataArray.count <= 0{
                cell.profileImage.image = UIImage(named: "pl")
            }else{
                cell.profileImage.sd_setImage(with: URL(string: ChoirCLDataArray [indexPath.row].image),placeholderImage: UIImage(named: "pl"))
                cell.nameLbl.text = ChoirCLDataArray[indexPath.row].name
                DispatchQueue.main.async {
                    self.choirCollectionHeight.constant = self.choirCollectionView.contentSize.height
                }
            }
            return cell
            
        } else if collectionView == studyCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "studyCollectionView", for: indexPath) as! studyCollectionView
            if studyCLDataArray.count <= 0 {
                cell.mainImage.image = UIImage(named: "pl")
            }else{
                cell.mainImage.sd_setImage(with: URL(string: studyCLDataArray[indexPath.row].image),placeholderImage: UIImage(named: "pl"))
            }
            cell.nameLbl.text = studyCLDataArray[indexPath.row].title
            return cell
            
        } else if collectionView == tblMens{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MensCell", for: indexPath) as! MensCell
            if mensDataArray.count <= 0 {
                cell.showImg.image = UIImage(named: "pl")
            }else{
                cell.showImg.sd_setImage(with: URL(string: mensDataArray[indexPath.row].image),placeholderImage: UIImage(named: "pl"))
            }
            cell.lblName.text = mensDataArray[indexPath.row].name
            return cell
            
        } else if collectionView == tblWomens{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WomenMinistry", for: indexPath) as! WomenMinistry
            if womensDataArray.count <= 0 {
                cell.showImg.image = UIImage(named: "pl")
            }else{
                cell.showImg.sd_setImage(with: URL(string: womensDataArray[indexPath.row].image),placeholderImage: UIImage(named: "pl"))
            }
            cell.lblName.text = womensDataArray[indexPath.row].name
            return cell
            
        } else if collectionView == tblTeens{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TennsMinistry", for: indexPath) as! TennsMinistry
            if teenDataArray.count <= 0 {
                cell.showImg.image = UIImage(named: "pl")
            }else{
                cell.showImg.sd_setImage(with: URL(string: teenDataArray[indexPath.row].image),placeholderImage: UIImage(named: "pl"))
            }
            cell.lblName.text = teenDataArray[indexPath.row].name
            return cell
            
        } else if collectionView == tblGlory{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GloryKids", for: indexPath) as! GloryKids
            if gloryDataArray.count <= 0 {
                cell.showImg.image = UIImage(named: "pl")
            }else{
                cell.showImg.sd_setImage(with: URL(string: gloryDataArray[indexPath.row].image),placeholderImage: UIImage(named: "pl"))
            }
            cell.lblName.text = gloryDataArray[indexPath.row].name
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == studyCollectionView{
            
            return CGSize(width: self.studyCollectionView.frame.size.width/2.5 , height: self.studyCollectionView.frame.size.height)
            
        }else {
            let get =  self.choirCollectionView.frame.size.width
            return CGSize(width: get/2.5, height: self.choirCollectionView.frame.size.height )
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == studyCollectionView {
            
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "9"
            vc.titleName = "Bible Study"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if collectionView == choirCollectionView {
            
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "2"
            vc.titleName = "Choir Reharsal"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if collectionView == tblMens {
            
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "4"
            vc.titleName = "Mens Ministry"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if collectionView == tblWomens {
            
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "3"
            vc.titleName = "Womens Ministry"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if collectionView == tblTeens {
            
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "5"
            vc.titleName = "Teens Ministry"
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if collectionView == tblGlory {
            
            let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
            vc.catId = "6"
            vc.titleName = "Glory Kids"
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

extension HomeScreenVC : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if upcomingDataArray.count <= 0 {
            self.upcomingTableView.setEmptyMessage("")
        }else {
            self.upcomingTableView.restore()
        }
        return upcomingDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingTableView", for: indexPath) as! upcomingTableView
        if upcomingDataArray.count <= 0 {
            
            cell.upcomingImg.image = UIImage(named: "pl")
            
        }else {
            cell.upcomingImg.sd_setImage(with: URL(string: upcomingDataArray [indexPath.row].image),placeholderImage: UIImage(named: "pl"))
            cell.titleLabel.text = upcomingDataArray[indexPath.row].title
            cell.detailLabel.text = upcomingDataArray[indexPath.row].detail
            cell.btnTap.tag = indexPath.row
            cell.btnTap.addTarget(self, action: #selector(gotoListingVC(sender:)), for: .touchUpInside)
        }
        
        return cell
    }
    
    
    @objc func gotoListingVC(sender: UIButton){
        let vc = ListingVC.instantiate(fromAppStoryboard: .Main)
        vc.catId = "10"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
}
struct AllHome {
    var bible : [BibleData]
    var choir : [ChoirCLData]
    var upcoming : [UpcomingData]
    var study : [StudyCLData]
    init(bible : [BibleData] ,choir : [ChoirCLData] ,upcoming : [UpcomingData],  study : [StudyCLData] ) {
        
        self.choir = choir
        self.upcoming = upcoming
        self.study = study
        self.bible = bible
    }
}
struct BibleData{
    var mimage : String
    var gimage : String
    var url : String
    init(mimage : String, gimage : String ,url : String) {
        self.mimage = mimage
        self.gimage = gimage
        self.url = url
    }
}

struct MensData{
    var image : String
    var name : String
    init(image : String , name : String) {
        self.image = image
        self.name = name
    }
}

struct WomenData{
    var image : String
    var name : String
    init(image : String , name : String) {
        self.image = image
        self.name = name
    }
}

struct TeenData{
    var image : String
    var name : String
    init(image : String , name : String) {
        self.image = image
        self.name = name
    }
}

struct GloryData{
    var image : String
    var name : String
    init(image : String , name : String) {
        self.image = image
        self.name = name
    }
}

struct  ChoirCLData {
    var image : String
    var name : String
    init(image : String , name : String) {
        self.image = image
        self.name = name
    }
}
struct UpcomingData {
    var image : String
    var title : String
    var detail : String
    init(image : String , title : String , detail : String) {
        self.image = image
        self.title = title
        self.detail = detail
    }
}

struct StudyCLData {
    var image : String
    var link : String
    var title : String
    init(image : String , link :String,title : String) {
        self.image = image
        self.link  = link
        self.title = title
    }
}
extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 80, y: 200, width: 290, height: 70))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel
        
    }
    
    func restore() {
        self.backgroundView = nil
        
    }
}


