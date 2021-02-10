//
//  DetailsVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 10/02/21.
//

import UIKit

class DetailsVC: UIViewController {
    
    var detailsDataArray = [DetailsData]()

    @IBOutlet weak var detailsTbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        detailsDataArray.append(DetailsData(image: "choir-rehersal", details: "aghgasdfggasgfhgsdhsd", name: "Men's ministry", date: "21Dec"))
        detailsDataArray.append(DetailsData(image: "choir-rehersal", details: "aghgasdfggasgfhgsdhsd", name: "Men's ministry", date: "21Dec"))
        detailsDataArray.append(DetailsData(image: "choir-rehersal", details: "aghgasdfggasgfhgsdhsd", name: "Men's ministry", date: "21Dec"))
        detailsDataArray.append(DetailsData(image: "choir-rehersal", details: "aghgasdfggasgfhgsdhsd", name: "Men's ministry", date: "21Dec"))
        detailsDataArray.append(DetailsData(image: "choir-rehersal", details: "aghgasdfggasgfhgsdhsd", name: "Men's ministry", date: "21Dec"))
        detailsTbView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButton(_ sender: Any) {
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}

class DetailsTbViewCell: UITableViewCell {
    
    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var detailsLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension DetailsVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTbViewCell", for: indexPath) as! DetailsTbViewCell
        cell.showImage.image = UIImage(named: detailsDataArray[indexPath.row].image)
        cell.nameLbl.text = detailsDataArray[indexPath.row].name
        cell.detailsLbl.text = detailsDataArray[indexPath.row].details
        cell.dateLbl.text = detailsDataArray[indexPath.row].date
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
    
    func applyShadowOnView(_ view: UIView) {
        view.layer.cornerRadius = 12
        view.layer.shadowColor = #colorLiteral(red: 0.9044200033, green: 0.9075989889, blue: 0.9171359454, alpha: 1)
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
    }
    
}

struct DetailsData {
    var image : String
    var details : String
    var name : String
    var date : String
    
    init(image : String , details : String , name : String , date : String) {
        self.image = image
        self.details = details
        self.name = name
        self.date = date
    }
}
