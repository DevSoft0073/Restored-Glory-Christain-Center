//
//  Men'sMinistryVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit
import LGSideMenuController

class Men_sMinistryVC: UIViewController {

    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var mensTbView: UITableView!
    var mensMinistryDataArray = [MensMinistryData]()
    var searchDataArray = [MensMinistryData]()
    var isSearch = false

    override func viewDidLoad() {
        
        super.viewDidLoad()
        mensTbView.separatorStyle = .none
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        mensMinistryDataArray.append(MensMinistryData(image: "choir-rehersal", title: "Live Sirmon"))
        searchDataView.isHidden = true


    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func searchButton(_ sender: Any) {
        isSearch = true
        if isSearch == false {
            searchDataView.isHidden = true
            
        }else{
            searchDataView.isHidden = false
            isSearch = false
        }
    }
    
    @IBAction func searchTxtFldAction(_ sender: UITextField) {
        
        if searchTxtFld.text != ""{
            self.searchDataArray = self.mensMinistryDataArray.filter{
                ($0.title).range(of: self.searchTxtFld.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            }
            mensTbView.reloadData()
        }else{
            searchDataArray = mensMinistryDataArray
            mensTbView.reloadData()
        }
        mensTbView.reloadData()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchDataView.isHidden = true
        isSearch = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchDataView.isHidden = true
        isSearch = false
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
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
