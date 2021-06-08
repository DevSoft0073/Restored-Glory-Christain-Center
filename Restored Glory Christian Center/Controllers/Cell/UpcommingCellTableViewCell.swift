//
//  UpcommingCellTableViewCell.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 08/06/21.
//

import UIKit

class UpcommingCellTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDes: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
