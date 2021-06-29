//
//  DetailsDataVC.swift
//  Restored Glory Christian Center
//
//  Created by Vivek Dharmani on 13/05/21.
//

import UIKit
import SDWebImage

class DetailsDataVC: UIViewController {
    
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailImage: UIImageView!
    var catID = String()
    var message = String()
    var linkID = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryDetails()
        self.roundedCorner()
        addBorders()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBorders()
        roundedCorner()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func roundedCorner(){
        let maskPath1 = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: 5, height: 5), byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 3, height: 3))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.path = maskPath1.cgPath
    }
    
    //MARK: Custome
    
    func categoryDetails() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            
            let signInUrl = Constant.shared.baseUrl + Constant.shared.detailsData
            let parms = ["c_id" : catID , "link_id" : linkID]
            print(signInUrl)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["category_details"] as? [String:Any]{
                        print(allData)
                        self.titleLbl.text = allData["title"] as? String ?? ""
                        self.detailsLbl.text = allData["description"] as? String ?? ""
                        self.detailImage.sd_setImage(with: URL(string: allData["image"] as? String ?? ""), placeholderImage: UIImage(named: "pl"), options: SDWebImageOptions.continueInBackground, completed: nil)
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
    
    
    func addBorders() {
        let thickness: CGFloat = 1.0
        let topBorder = CALayer()
        let rightBorder = CALayer()
        let leftBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width , height: thickness)
        topBorder.backgroundColor = #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1)
        rightBorder.frame = CGRect(x:self.view.frame.size.width - thickness, y: 0, width: thickness, height:self.view.frame.size.width)
        rightBorder.backgroundColor = #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1)
        leftBorder.frame = CGRect(x:0, y: 0, width: thickness, height:self.view.frame.size.width)
        leftBorder.backgroundColor = #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1)
        detailImage.layer.addSublayer(topBorder)
        detailImage.layer.addSublayer(rightBorder)
        detailImage.layer.addSublayer(leftBorder)
    }
}








