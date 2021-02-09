//
//  Men'sMinistryVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit
import LGSideMenuController

class Men_sMinistryVC: UIViewController {

    @IBOutlet weak var mensTbView: UITableView!
    var mensMinistryDataArray = [MensMinistryData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        mensTbView.separatorStyle = .none
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))


    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func searchButton(_ sender: Any) {
    }
    
}

class MensTbViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension Men_sMinistryVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mensMinistryDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell
            = tableView.dequeueReusableCell(withIdentifier: "MensTbViewCell", for: indexPath) as! MensTbViewCell
        cell.showImage.image = UIImage(named: mensMinistryDataArray[indexPath.row].image)
        cell.titleLbl.text = mensMinistryDataArray[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}

struct MensMinistryData {
    var image : String
    var title : String
    
    init(image : String , title : String ) {
        self.image = image
        self.title = title
    }
}
