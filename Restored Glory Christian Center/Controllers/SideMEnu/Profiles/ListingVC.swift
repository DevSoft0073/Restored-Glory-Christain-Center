//
//  ListingVC.swift
//  Restored Glory Christian Center
//
//  Created by Vivek Dharmani on 19/05/21.
//

import UIKit

class ListingVC: UIViewController {
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var listCollectionView: UICollectionView!
    var message = String()
    var searchDataArray = [ListCLData]()
    var listCLDataArray = [ListCLData]()
    var catId = String()
    var catName =  String()
    var titleName = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        listingDetails()
        self.titlelbl.text = titleName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        listingDetails()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func listingDetails(){
        if Reachability.isConnectedToNetwork() == true {
            print("Internet Connection OK")
            IJProgressView.shared.showProgressView()
            let id = UserDefaults.standard.value(forKey: "id") ?? ""
            let listingUrl = Constant.shared.baseUrl + Constant.shared.DetailsByCat
            print("listingUrl")
            let parms : [String:Any] = ["c_id" : self.catId , "search" : "" , "user_id" : id]
            print("parms")
            AFWrapperClass.requestPOSTURL(listingUrl, params: parms, success: {(response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.listCLDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response ["status"] as? Int
                if status == 1 {
                    if let allData = response["data"] as? [[String:Any]] {
                        for obj in allData {
                            self.listCLDataArray.append(ListCLData(image: obj["image"] as? String ?? "", name: obj["title"] as? String ?? "", time: obj["servercreated_at"] as? String ?? "", content: obj["description"] as? String ?? "", link: obj["link"] as? String ?? "", id: obj["link_id"] as? String ?? "",likeCount: obj["total_likes"] as? String ?? "",commentCount: obj["total_comments"] as? String ?? "", isLike: obj["isLike"] as? String ?? ""))
                        }                    }
                    self.searchDataArray =  self.listCLDataArray
                    self.listCollectionView.reloadData()
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
                
            }) {(error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
        }else{
            print("Internet Connection Failed")
            alert(Constant.shared.appTitle, message: "Check Internet Connection", view: self)
        }
    }
    
}
class listCollectionView : UICollectionViewCell {
    
    @IBOutlet weak var imgShare: UIImageView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var lblLike: UILabel!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
extension ListingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCLDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "listCollectionView", for: indexPath) as! listCollectionView
        cell.mainImg.sd_setImage(with: URL(string: listCLDataArray [indexPath.row].image), placeholderImage: UIImage(named: "pl"))
        cell.nameLbl.text = listCLDataArray[indexPath.row].name
        cell.typeLbl.text = listCLDataArray[indexPath.row].content
        cell.lblLike.text = listCLDataArray[indexPath.row].likeCount
        cell.lblComment.text = listCLDataArray[indexPath.row].commentCount
        cell.btnComment.tag = indexPath.row
        
        if listCLDataArray[indexPath.row].isLike == "1" {
            cell.imgLike.image = UIImage(named: "like1")
        } else if listCLDataArray[indexPath.row].isLike == "0" {
            cell.imgLike.image = UIImage(named: "like")
        } else if listCLDataArray[indexPath.row].isLike == "" {
            cell.imgLike.image = UIImage(named: "like")
        }
        cell.btnComment.addTarget(self, action: #selector(btnComment(sender:)), for: .touchUpInside)
        cell.btnShare.tag = indexPath.row
        cell.btnLike.tag = indexPath.row
        cell.btnShare.addTarget(self, action: #selector(shareBtnAction(sender:)), for: .touchUpInside)
        cell.btnLike.addTarget(self, action: #selector(likeUnlikeBtnAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func likeUnlikeBtnAction(sender : UIButton) {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        IJProgressView.shared.showProgressView()
        let CategoryData = Constant.shared.baseUrl + Constant.shared.likeUnlike
        let parms : [String:Any] = ["user_id":id, "link_id": listCLDataArray[sender.tag].id]
        AFWrapperClass.requestPOSTURL(CategoryData, params: parms, success: { (response) in
            print(response)
            IJProgressView.shared.hideProgressView()
            let status = response["status"] as? Int ?? 0
            let msg = response["message"] as? String ?? ""
            print(status)
            if status == 1{
                self.listCLDataArray[sender.tag].isLike = self.listCLDataArray[sender.tag].isLike == "0" ? "1" : "0"
                var likeCount = NumberFormatter().number(from: self.listCLDataArray[sender.tag].likeCount)?.intValue ?? 0
                likeCount =  self.listCLDataArray[sender.tag].isLike == "1" ? likeCount+1 : likeCount-1
                self.listCLDataArray[sender.tag].isLike = "\(likeCount)"
                self.listingDetails()
            }else{
                alert(Constant.shared.appTitle, message: msg, view: self)
            }
        })
        { (error) in
            IJProgressView.shared.hideProgressView()
            print(error)
        }
    }
    
    @objc func shareBtnAction(sender : UIButton) {
        IJProgressView.shared.showProgressView()
        AFWrapperClass.createContentDeepLink(title: Constant.shared.appTitle, type: "Post", OtherId: listCLDataArray[sender.tag].id, description: "Hey, look at this post.", image: listCLDataArray[sender.tag].link == "" ? listCLDataArray[sender.tag].link : listCLDataArray[sender.tag].id, link: listCLDataArray[sender.tag].link == "" ? listCLDataArray[sender.tag].link : listCLDataArray[sender.tag].link) { urlStr in
            IJProgressView.shared.hideProgressView()
            if let url = URL(string: urlStr ?? "") {
                print(urlStr)
                let objectsToShare = ["Hey, look at this post.",url] as [Any]
                AFWrapperClass.presentShare(objectsToShare: objectsToShare, vc: self)
            }
        }
    }

    
    @objc func btnComment(sender : UIButton) {
        let vc = CommentVC.instantiate(fromAppStoryboard: .Main)
        vc.postID = listCLDataArray[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size , height: size + 70)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if catId == "9"{
            
            UIApplication.shared.open(URL(string: listCLDataArray[indexPath.row].link)!, options: [:], completionHandler: nil)
            
        } else {
            
            let vc = DetailsDataVC.instantiate(fromAppStoryboard: .Main)
            vc.catID = self.catId
            vc.linkID = listCLDataArray[indexPath.row].id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

struct ListCLData {
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
