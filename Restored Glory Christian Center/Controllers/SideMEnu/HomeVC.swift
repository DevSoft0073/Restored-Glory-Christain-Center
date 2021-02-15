//
//  HomeVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 06/02/21.
//

import UIKit
import LGSideMenuController

class HomeVC: UIViewController {
    
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var showAllDataTbView: UITableView!
    var allDataArray = [AllData]()
    var searchDataArray = [SearchData]()
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        allDataArray.append(AllData(title: "Live Sirmon", image: "youth"))
        
        searchDataArray.append(SearchData(title: "Live Sirmon", image: "youth"))
        searchDataArray.append(SearchData(title: "Live Sirmon", image: "youth"))

        
        searchView.isHidden = true
        showAllDataTbView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    @IBAction func addLinkButton(_ sender: Any) {
        let vc = AddLinkVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        self.searchView.isHidden = true
        isSearch = false
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        self.searchView.isHidden = true
        isSearch = false
    }

    
    @IBAction func searchButtonAction(_ sender: Any) {
        if isSearch == false {
            searchView.isHidden = true
            isSearch = true
        }else{
            searchView.isHidden = false
            isSearch = false
        }
    }
    
    func searchData( word: String)  {
        if isSearch == true {
            
        }else{
            
        }
    }
    
    @IBAction func openMenu(_ sender: Any) {
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
        if isSearch == true {
            return searchDataArray.count
        }else {
            return allDataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowAllDataTbViewCell", for: indexPath) as! ShowAllDataTbViewCell
        cell.titleLbl.text = allDataArray[indexPath.row].title
        cell.images.image = UIImage(named: allDataArray[indexPath.row].image)
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

struct AllData {
    var title : String
    var image : String
    
    init(title : String , image : String) {
        self.title = title
        self.image = image
    }
}

struct SearchData {
    var title : String
    var image : String
    
    init(title : String , image : String) {
        self.title = title
        self.image = image
    }
}
