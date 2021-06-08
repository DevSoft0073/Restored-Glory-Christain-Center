//
//  DetailsDataVC.swift
//  Restored Glory Christian Center
//
//  Created by Vivek Dharmani on 13/05/21.
//

import UIKit

class DetailsDataVC: UIViewController {

    
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.roundedCorner()
        addBorders()
//        addBorder(edge:.top, color: #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1), thickness: 3)
//        addBorder(edge:.right, color: #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1), thickness: 3)
//        addBorder(edge:.left, color: #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1), thickness: 3)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBorders()
        roundedCorner()
    }

    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func roundedCorner(){
        let maskPath1 = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: 5, height: 5), byRoundingCorners: [.topLeft , .topRight],
            cornerRadii: CGSize(width: 3, height: 3))
        let maskLayer1 = CAShapeLayer()
//        maskLayer1.view.frame = bounds
        maskLayer1.path = maskPath1.cgPath
    }
    
    func addBorders() {
       let thickness: CGFloat = 1.0
       let topBorder = CALayer()
       let rightBorder = CALayer()
       let leftBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width , height: thickness)
       topBorder.backgroundColor = #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1)
        rightBorder.frame = CGRect(x:self.view.frame.size.width - thickness, y: 0, width: thickness, height:self.view.frame.size.width)
       rightBorder.backgroundColor = #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1)
        leftBorder.frame = CGRect(x:0, y: 0, width: thickness, height:self.view.frame.size.width)
       leftBorder.backgroundColor = #colorLiteral(red: 0.7631496787, green: 0.4526302218, blue: 0.110665448, alpha: 1)
       detailImage.layer.addSublayer(topBorder)
       detailImage.layer.addSublayer(rightBorder)
       detailImage.layer.addSublayer(leftBorder)
    }
       }








