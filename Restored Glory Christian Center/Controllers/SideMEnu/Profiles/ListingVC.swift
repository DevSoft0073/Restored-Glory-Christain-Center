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
            let parms : [String:Any] = ["c_id" : self.catId ?? String() , "search" : ""]
            print("parms")
            AFWrapperClass.requestPOSTURL(listingUrl, params: parms, success: {(response) in
                IJProgressView.shared.hideProgressView()
                print(response)
                self.listCLDataArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response ["status"] as? Int
                if status == 1 {
                    if let allData = response["data"] as? [[String:Any]] {
                        for obj in allData{
                            self.listCLDataArray.append(ListCLData(image: obj["image"] as? String ?? "", name: obj["title"] as? String ?? "", type: obj["description"] as? String ?? "", link: obj["link"] as? String ?? "")
                            )
                        }
                    }
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
//        cell.mainImg.image = UIImage(named: listCLDataArray[indexPath.row].image)
        cell.mainImg.sd_setImage(with: URL(string: listCLDataArray [indexPath.row].image), placeholderImage: UIImage(named: "pl"))
        cell.nameLbl.text = listCLDataArray[indexPath.row].name
        cell.typeLbl.text = listCLDataArray[indexPath.row].type
        
        return cell
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
        }else{
            
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
    var type : String
    var link : String
    init(image : String , name : String , type : String , link : String) {
        self.image = image
        self.name = name
        self.type = type
        self.link = link
    }
}
