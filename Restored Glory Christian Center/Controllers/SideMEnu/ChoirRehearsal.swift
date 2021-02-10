//
//  ChoirRehearsal.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 10/02/21.
//

import UIKit
import LGSideMenuController

class ChoirRehearsal: UIViewController {
    
    var ChoirRehearsalDataArray = [ChoirRehearsalData]()
    @IBOutlet weak var dataTbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
        ChoirRehearsalDataArray.append(ChoirRehearsalData(title: "Live Sirmon", image: "choir-rehersal"))
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menuButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()

    }
    
    @IBAction func searchButton(_ sender: Any) {
    }
    
}


class DataTbViewCell: UITableViewCell {
    
    @IBOutlet weak var showImage: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ChoirRehearsal : UITableViewDelegate ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChoirRehearsalDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTbViewCell", for: indexPath) as! DataTbViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
}

struct ChoirRehearsalData {
    var title : String
    var image : String
    
    init(title : String , image : String) {
        self.title = title
        self.image = image
    }
}
