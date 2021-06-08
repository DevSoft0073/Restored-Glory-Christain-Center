//
//  NewHomeVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 05/06/21.
//

import UIKit
import Foundation
import SDWebImage

class NewHomeVC : UIViewController {
    
    @IBOutlet weak var tblHome: UITableView!
    
    var message = String()
    var ChoirCLDataArray = [ChoirCLData]()
    var studyCLDataArray = [StudyCLData]()
    var upcomingDataArray = [UpcomingData]()
    var bibleDataArray = [BibleData]()
    var AllHomeArray = [AllHome]()
    var imageDataArray = [String]()
    var catId = String()
    var catName = String()
    
    
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
    
    func setup() {
        
        var identifier = String(describing: LiveStreamCell.self)
        var nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHome.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: HomeCell.self)
        nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHome.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        identifier = String(describing: UpcommingCellTableViewCell.self)
        nibProfileCell = UINib(nibName: identifier, bundle: Bundle.main)
        tblHome.register(nibProfileCell, forCellReuseIdentifier: identifier)
        
        updateUI()
    }
    
    func updateUI() {
        
        tblHome.reloadData()
        
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
                                        self.studyCLDataArray.append(StudyCLData(image: i["image"] as? String ?? "", link: i["link"] as? String ?? ""))
                                    }
                                    else if self.catId == "7"{
                                        print(i)
//                                        self.mainImg.sd_setImage(with: URL(string: i["image"] as? String ?? ""), placeholderImage: UIImage(named: "pl"), options: SDWebImageOptions.continueInBackground, completed: nil)
//                                        self.liveIcon.loadGif(name: "tower")
                                        self.bibleDataArray.append(BibleData(mimage: i["image"] as? String ?? "", gimage: i["image"] as? String ?? ""))
                                        
                                    }
                                    else if self.catId == "2" {
                                        print(i)
                                        
                                        self.ChoirCLDataArray.append(ChoirCLData(image: i["image"] as? String ?? "", name: i["title"] as? String ?? ""))
                                    }
                                }
                            }
                        }
                        print(self.upcomingDataArray)
                        
//                        self.choirCollectionView.reloadData()
//                        self.studyCollectionView.reloadData()
//                        self.upcomingTableView.reloadData()
//                        self.noDataChoirLbl.isHidden = self.ChoirCLDataArray.count == 0 ? false : true
//                        self.noDataUpcomingLbl.isHidden = self.upcomingDataArray.count == 0 ? false : true
//                        self.noDataStudyLbl.isHidden = self.studyCLDataArray.count == 0 ? false : true
                        
                    }else {
                        IJProgressView.shared.hideProgressView()
                        alert(Constant.shared.appTitle, message: self.message, view: self)
                        
                    }
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
    
    //------------------------------------------------------
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}

extension NewHomeVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            let view: HeaderView = UIView.fromNib()
            view.layoutSubviews()
            return view.bounds.height
            
        } else if section == 1 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Choir Reharsal"
            view.layoutSubviews()
            return view.bounds.height
            
        } else if section == 2 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Upcomming Event"
            view.layoutSubviews()
            return view.bounds.height
            
        } else if section == 3 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Bible Study"
            view.layoutSubviews()
            return view.bounds.height
            
        } else if section == 4 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Mens Ministry"
            view.layoutSubviews()
            return view.bounds.height
            
        } else if section == 5 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Womens Ministry"
            view.layoutSubviews()
            return view.bounds.height
            
        } else if section == 6 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Teens Ministry"
            view.layoutSubviews()
            return view.bounds.height
            
        } else if section == 7 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Glory Kids"
            view.layoutSubviews()
            return view.bounds.height
            
        }
        return view.bounds.height
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0{
            let view: HeaderView = UIView.fromNib()
            view.layoutSubviews()
            return UIView()
            
        } else if section == 1 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Choir Reharsal"
            view.layoutSubviews()
            return UIView()
            
        } else if section == 2 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Upcomming Event"
            view.layoutSubviews()
            return UIView()
            
        } else if section == 3 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Bible Study"
            view.layoutSubviews()
            return UIView()
            
        } else if section == 4 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Mens Ministry"
            view.layoutSubviews()
            return UIView()
            
        } else if section == 5 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Womens Ministry"
            view.layoutSubviews()
            return UIView()
            
        } else if section == 6 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Teens Ministry"
            view.layoutSubviews()
            return UIView()
            
        } else if section == 7 {
            let view: HeaderView = UIView.fromNib()
            view.titleLbl.text = "Glory Kids"
            view.layoutSubviews()
            return UIView()
            
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeCell.self)) as? HomeCell {
                return cell
            }
            
        }else if  indexPath.row == 1{
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UpcommingCellTableViewCell.self)) as? UpcommingCellTableViewCell {
                return cell
            }
            
        } else {
            
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeCell.self)) as? HomeCell {
                return cell
            }
        }
        return UITableViewCell()
    }
}
