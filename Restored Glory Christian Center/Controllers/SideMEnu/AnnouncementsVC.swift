//
//  AnnouncementsVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit
import LGSideMenuController

class AnnouncementsVC: UIViewController {

    @IBOutlet weak var adminTBView: UITableView!
    var adminTBDataArray = [AdminTBData]()
    var isSearch = false

//    var searchDataArray = [AdminTBData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.adminTBView.separatorStyle = .none
        adminTBDataArray.append(AdminTBData(image: "placehlder", name: "youth", details: "asasdadsaaa"))
        adminTBDataArray.append(AdminTBData(image: "placehlder", name: "youth", details: "asasdadsaaa"))
        adminTBDataArray.append(AdminTBData(image: "placehlder", name: "youth", details: "asasdadsaaa"))
        adminTBDataArray.append(AdminTBData(image: "placehlder", name: "youth", details: "asasdadsaaa"))
        adminTBDataArray.append(AdminTBData(image: "placehlder", name: "youth", details: "asasdadsaaa"))
        adminTBDataArray.append(AdminTBData(image: "placehlder", name: "youth", details: "asasdadsaaa"))
        adminTBDataArray.append(AdminTBData(image: "placehlder", name: "youth", details: "asasdadsaaa"))
        adminTBView.separatorStyle = .none
    }
    
    @IBAction func backButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
//        self.navigationController?.popViewController(animated: true)
    }
    
}

class AdminTBView_Cell: UITableViewCell {
    
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension AnnouncementsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adminTBDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdminTBView_Cell", for: indexPath) as! AdminTBView_Cell
        cell.profileImage.image = UIImage(named: adminTBDataArray[indexPath.row].image)
        cell.nameLbl.text = adminTBDataArray[indexPath.row].name
        cell.detailLbl.text = adminTBDataArray[indexPath.row].details
        cell.profileImage.setRounded()
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

struct AdminTBData {
    var image : String
    var name : String
    var details : String
    
    init(image : String , name : String , details : String) {
        self.image = image
        self.name = name
        self.details = details
    }
}
