//
//  HomeVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController {

    @IBOutlet weak var showAllDataTbView: UITableView!
    var allDataArray = [AllData]()
    override func viewDidLoad() {
        super.viewDidLoad()

        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        showAllDataTbView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenu(_ sender: UIButton) {
        sideMenuController?.showLeftViewAnimated()
    }
}

class ShowAllDataTbViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var images: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}

extension HomeVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAllDataTbViewCell", for: indexPath) as! ShowAllDataTbViewCell
        cell.titleLbl.text = allDataArray[indexPath.row].title
        cell.images.image = UIImage(named: allDataArray[indexPath.row].image)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}

struct AllData {
    var title : String
    var image : String
    
    init(title : String , image : String) {
        self.title = title
        self.image = image
    }
}
