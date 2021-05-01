//
//  SideMenuVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit
import LGSideMenuController

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var adminButtonTopLbl: UILabel!
    @IBOutlet weak var adminButton: UIButton!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var sideMenuTbView: UITableView!
    var titleArray = [String]()
    var sideMenuArray : [SideMenuData] = []{
        didSet{
            sideMenuTbView.reloadData()
        }
    }
    var message = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        sideMenuTbView.separatorStyle = .none
        adminButton.contentHorizontalAlignment = .left
        let role = (UserDefaults.standard.value(forKey: "checkRole") as? String ?? "")
        if role == "0" {
            sideMenuArray.append(SideMenuData(name: "Home", selected: true))
//            sideMenuArray.append(SideMenuData(name: "Encouraging Words", selected: false))
            sideMenuArray.append(SideMenuData(name: "Choir Rehearsal", selected: false))
            sideMenuArray.append(SideMenuData(name: "Mens Ministry", selected: false))
            sideMenuArray.append(SideMenuData(name: "Womens Ministry", selected: false))
            sideMenuArray.append(SideMenuData(name: "Teen Ministry", selected: false))
            sideMenuArray.append(SideMenuData(name: "Glory Kids ", selected: false))
            sideMenuArray.append(SideMenuData(name: "About Us", selected: false))
            sideMenuArray.append(SideMenuData(name: "Contact Us", selected: false))
            sideMenuArray.append(SideMenuData(name: "Logout", selected: false))
        }else{
            sideMenuArray.append(SideMenuData(name: "Home", selected: true))
//            sideMenuArray.append(SideMenuData(name: "Encouraging Words", selected: false))
//            sideMenuArray.append(SideMenuData(name: "Upcoming Events", selected: false))
            sideMenuArray.append(SideMenuData(name: "Choir Rehearsal", selected: false))
            sideMenuArray.append(SideMenuData(name: "Mens Ministry", selected: false))
            sideMenuArray.append(SideMenuData(name: "Womens Ministry", selected: false))
            sideMenuArray.append(SideMenuData(name: "Teen Ministry", selected: false))
            sideMenuArray.append(SideMenuData(name: "Glory Kids ", selected: false))
            sideMenuArray.append(SideMenuData(name: "About Us", selected: false))
            sideMenuArray.append(SideMenuData(name: "Contact Us", selected: false))
            sideMenuArray.append(SideMenuData(name: "Logout", selected: false))
            sideMenuArray.append(SideMenuData(name: "Admin", selected: false))
        }
        
    
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.height/2
    }
    
    @IBAction func adminButton(_ sender: UIButton) {
    }
    
    @IBAction func openProfile(_ sender: Any) {
        sideMenuController?.hideLeftViewAnimated()
        let vc = ProfileVC.instantiate(fromAppStoryboard: .Main)
        (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
    }
    
    func getData() {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            let signInUrl = Constant.shared.baseUrl + Constant.shared.Profile
            print(signInUrl)
            let parms : [String:Any] = ["user_id" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                print(response)
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["data"] as? [String:Any]{
                        self.nameLbl.text = "\(allData["first_name"] as? String ?? "") " + "\(allData["last_name"] as? String ?? "")"
                        self.emailLbl.text = allData["email"] as? String
                        self.profileImage.sd_setImage(with: URL(string:allData["photo"] as? String ?? ""), placeholderImage: UIImage(named: "placehlder"))
                        let url = URL(string:allData["photo"] as? String ?? "")
                        if url != nil{
                            if let data = try? Data(contentsOf: url!)
                            {
                                if let image: UIImage = (UIImage(data: data)){
                                    self.profileImage.image = image
                                    self.profileImage.contentMode = .scaleToFill
                                    IJProgressView.shared.hideProgressView()
                                }
                            }
                        }
                        else{
                            self.profileImage.image = UIImage(named: "placehlder")
                        }
                    }
                }else{
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }) { (error) in
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }
    
    func logout()  {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        UserDefaults.standard.removeObject(forKey: "checkRole")
        appDel.Logout1()
    }
    
}

class SideMenuTbViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension SideMenuVC : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "SideMenuTbViewCell", for: indexPath) as! SideMenuTbViewCell
        cell.titleLbl.text = sideMenuArray[indexPath.row].name
        if sideMenuArray[indexPath.row].selected == true{
            cell.titleLbl.textColor = #colorLiteral(red: 0, green: 0.06385789067, blue: 0.6515093446, alpha: 1)

        }else{
            cell.titleLbl.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sideMenuArray = sideMenuArray.map({ (obj) -> SideMenuData in
            var mutableObj = obj
            mutableObj.selected = false
            return mutableObj
        })
        sideMenuArray[indexPath.row].selected = true
        sideMenuController?.hideLeftViewAnimated()
        UserDefaults.standard.setValue(true, forKey: "sideMenu")
        let role = (UserDefaults.standard.value(forKey: "checkRole") as? String ?? "")
        if role == "0" {
            
            if(indexPath.row == 0) {
                let vc = HomeVC.instantiate(fromAppStoryboard: .Main)
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            }
                
//            else if(indexPath.row == 1) {
//                let vc = AnnouncementsVC.instantiate(fromAppStoryboard: .Main)
//                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
//            }
            else if(indexPath.row == 1) {
//                let vc = DetailsVC.instantiate(fromAppStoryboard: .Main)
//                vc.catName = "Upcoming Events"
//                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "2"
                vc.catTitle = "Choir Rehearsal"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            }
                
            else if(indexPath.row == 2) {
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "4"
                vc.catTitle = "Men's Ministry"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            }
                
            else if(indexPath.row == 3) {
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "3"
                vc.catTitle = "Women's Ministry "
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            }
                
            else if(indexPath.row == 4) {
                
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "5"
                vc.catTitle = "Teen Ministry"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            }else if(indexPath.row == 5) {
                
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "6"
                vc.catTitle = "Glory Kids"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            }else if(indexPath.row == 6) {
                
                let vc = AboutUSVC.instantiate(fromAppStoryboard: .Main)
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            } else if(indexPath.row == 7) {
                
                let vc = ContactUSVC.instantiate(fromAppStoryboard: .Main)
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            }else if(indexPath.row == 8) {
                
                let dialogMessage = UIAlertController(title: Constant.shared.appTitle, message: "Are you sure you want to Logout?", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button click...")
                    self.logout()
                })
                
                // Create Cancel button with action handlder
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    print("Cancel button click...")
                }
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
            }
            
        }else{
            
            if(indexPath.row == 0) {
                let vc = HomeVC.instantiate(fromAppStoryboard: .Main)
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            }
                
//            else if(indexPath.row == 1) {
//                let vc = AnnouncementsVC.instantiate(fromAppStoryboard: .Main)
//                vc.catTitle = "Encouraging Words"
//                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
//            }
//            else if(indexPath.row == 2) {
//                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
//                vc.catTitle = "Upcoming Events"
//                UserDefaults.standard.setValue(true, forKey: "comesFromSideMenu")
//                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
//            }
//
            else if(indexPath.row == 1) {
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "2"
                vc.catTitle = "Choir Rehearsal"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            }
                
            else if(indexPath.row == 2) {
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "4"
                vc.catTitle = "Men's Ministry"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            }
                
            else if(indexPath.row == 3) {
                
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "3"
                vc.catTitle = "Women's Ministry"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            }else if(indexPath.row == 4) {
                
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "5"
                vc.catTitle = "Teen Ministry"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            }else if(indexPath.row == 5) {
                
                let vc = ShowDescriptioVC.instantiate(fromAppStoryboard: .Main)
                vc.catID = "6"
                vc.catTitle = "Glory Kids"
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            } else if(indexPath.row == 6) {
                
                let vc = AboutUSVC.instantiate(fromAppStoryboard: .Main)
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
                
            }else if(indexPath.row == 7) {
                
                let vc = ContactUSVC.instantiate(fromAppStoryboard: .Main)
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            }
            
            else if(indexPath.row == 8) {
                
                let dialogMessage = UIAlertController(title: Constant.shared.appTitle, message: "Are you sure you want to Logout?", preferredStyle: .alert)
                
                // Create OK button with action handler
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button click...")
                    self.logout()
                })
                
                // Create Cancel button with action handlder
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    print("Cancel button click...")
                }
                
                //Add OK and Cancel button to dialog message
                dialogMessage.addAction(ok)
                dialogMessage.addAction(cancel)
                
                // Present dialog message to user
                self.present(dialogMessage, animated: true, completion: nil)
                
            }
            else if(indexPath.row == 9) {
                
                let vc = AdminVC.instantiate(fromAppStoryboard: .Main)
                (sideMenuController?.rootViewController as! UINavigationController).pushViewController(vc, animated: true)
            }
            
        }
    }
}


struct SideMenuData {
    var name : String
    var selected : Bool
    
    init(name : String,selected : Bool) {
        self.name = name
        self.selected = selected
    }
}
