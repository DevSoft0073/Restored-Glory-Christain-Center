//
//  Women'sMinistryVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit

class Women_sMinistryVC: UIViewController {

    @IBOutlet weak var womensDataTBVIew: UITableView!
    var womenDataArray = [WomensData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))
        womenDataArray.append(WomensData(image: "choir-rehersal", title: "Live Sirmon"))


        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    @IBAction func searchButton(_ sender: Any) {
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
