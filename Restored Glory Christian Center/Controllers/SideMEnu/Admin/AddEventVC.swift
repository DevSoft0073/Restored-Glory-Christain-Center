//
//  AddEventVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 23/03/21.
//

import UIKit

class AddEventVC: UIViewController ,UITextFieldDelegate{

    @IBOutlet weak var eventNameTxtFld: UITextField!
    @IBOutlet weak var eventView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        if eventNameTxtFld.text?.isEmpty == true {
            ValidateData(strMessage: "Event name shou;d not be empty")
        }else{
            addEvent()
        }
    }
    
    func addEvent()  {
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
