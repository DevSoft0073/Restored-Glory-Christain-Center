//
//  ChoirRehearsal.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 10/02/21.
//

import UIKit
import LGSideMenuController

class ChoirRehearsal: UIViewController {
    
    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var searchTxtFld: UITextField!
    var ChoirRehearsalDataArray = [ChoirRehearsalData]()
    var searchDataArray = [ChoirRehearsalData]()
    var isSearch = false

    @IBOutlet weak var dataTbView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchDataView.isHidden = true

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
        isSearch = true
        if isSearch == false {
            searchDataView.isHidden = true
            
        }else{
            searchDataView.isHidden = false
            isSearch = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchDataView.isHidden = true
        isSearch = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchDataView.isHidden = true
        isSearch = false
    }
    
    
    
    @IBAction func searchTxtFldAction(_ sender: UITextField) {
        
        if searchTxtFld.text != ""{
            self.searchDataArray = self.ChoirRehearsalDataArray.filter{
                ($0.title).range(of: self.searchTxtFld.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            }
            dataTbView.reloadData()
        }else{
            searchDataArray = ChoirRehearsalDataArray
            dataTbView.reloadData()
        }
        dataTbView.reloadData()
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
