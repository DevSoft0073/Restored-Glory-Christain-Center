//
//  Women'sMinistryVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit

class Women_sMinistryVC: UIViewController {

    @IBOutlet weak var searchDataView: UIView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var womensDataTBVIew: UITableView!
    var womenDataArray = [WomensData]()
    var searchDataArray = [WomensData]()
    var isSearch = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        searchDataView.isHidden = true

        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.searchDataView.isHidden = true
        isSearch = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.searchDataView.isHidden = true
        isSearch = false
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
    
    @IBAction func searchtxtFldAction(_ sender: UITextField) {
        if searchTxtFld.text != ""{
            self.searchDataArray = self.womenDataArray.filter{
                ($0.title).range(of: self.searchTxtFld.text!, options: [.diacriticInsensitive, .caseInsensitive]) != nil
            }
            womensDataTBVIew.reloadData()
        }else{
            searchDataArray = womenDataArray
            womensDataTBVIew.reloadData()
        }
        womensDataTBVIew.reloadData()
    }
}

class WomensDataTBVIewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension Women_sMinistryVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return womenDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WomensDataTBVIewCell", for: indexPath) as! WomensDataTBVIewCell
        cell.titleLbl.text = womenDataArray[indexPath.row].title
        cell.showImage.image = UIImage(named: womenDataArray[indexPath.row].image)
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

struct WomensData {
    var image : String
    var title : String
    
    init(image : String , title : String) {
        self.image = image
        self.title = title
    }
}
