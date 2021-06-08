//
//  AddLinkVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 09/02/21.
//

import UIKit

class AddLinkVC : UIViewController , UITextFieldDelegate ,UITextViewDelegate ,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var linkViewHeight: NSLayoutConstraint!
    @IBOutlet weak var linkView: UIView!
    @IBOutlet weak var descriptionTxtView: UITextView!
    @IBOutlet weak var addlinkTxtFld: UITextField!
    @IBOutlet weak var titleTxtFld: UITextField!
    @IBOutlet weak var selectTypeTxtFld: UITextField!
    @IBOutlet weak var showUploadImage: UIImageView!
//    var selectTypePickerViewArray = ["MISC","VIP","MEXICAN","BURGERS","BREAKFAST","STAFF PICKS","CHINESE","DESERT"]
    var picker  = UIPickerView()
    var message = String()
    var base64 = String()
    var imagePicker = UIImagePickerController()
    var pickerToolBar = UIToolbar()
    var selectedValue = String()
    var listingArray = [CategoryList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryListing()
        picker = UIPickerView.init()
        picker.delegate = self
        pickerToolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(title: "Done", style:.plain, target: self, action: #selector(onDoneButtonTapped))
        doneBtn.tintColor = #colorLiteral(red: 0.08110561222, green: 0.2923257351, blue: 0.6798375845, alpha: 1)
//        doneBtn.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 20)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        pickerToolBar.setItems([spaceButton,doneBtn], animated: false)
        pickerToolBar.isUserInteractionEnabled = true
        selectTypeTxtFld.inputView = picker
        selectTypeTxtFld.inputAccessoryView = pickerToolBar
        picker.reloadAllComponents()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadButton(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func openPickerView(_ sender: Any) {
//        categoryListing()
    }
    @IBAction func submitButtonAction(_ sender: Any) {
        
        
        if selectTypeTxtFld.text == "Live Stream" || selectTypeTxtFld.text == "Bible Study" {
            if (selectTypeTxtFld.text?.isEmpty)!{
                
                ValidateData(strMessage: "Select type field should not be empty")
            }
            else if (titleTxtFld.text?.isEmpty)!{
                
                ValidateData(strMessage: "Title field should not be empty")
                
            }else if (addlinkTxtFld.text?.isEmpty)!{
                
                ValidateData(strMessage: "Add link field should not be empty")
                
            }else if isValidUrl(url: (addlinkTxtFld.text)!) == false{
                
                ValidateData(strMessage: "Enter valid url")
                
            }else{
                
                addLink()
            }
        }else{
            if (selectTypeTxtFld.text?.isEmpty)!{
                
                ValidateData(strMessage: "Select type field should not be empty")
            }
            else if (titleTxtFld.text?.isEmpty)!{
                
                ValidateData(strMessage: "Title field should not be empty")
                
            }else{
                
                addLink()
                
            }
        }
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
    @objc func onDoneButtonTapped(sender:UIButton) {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == selectTypeTxtFld {
//            categoryListing()
        }
    }
    
    
    //    MARK:->    Picker View Methods
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        listingArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedValue = listingArray[row].catId as String
        selectTypeTxtFld.text = listingArray[row].title
        selectedValue = listingArray[row].catId
        print(selectedValue)
        if selectTypeTxtFld.text == "Live Stream" || selectTypeTxtFld.text == "Bible Study" {
            linkViewHeight.constant = 70
        }else{
            linkViewHeight.constant = 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.font = UIFont(name: "Roboto-Medium", size: 20)
        label.text = listingArray[row].title
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    
    
    func categoryListing() {
        
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let signInUrl = Constant.shared.baseUrl + Constant.shared.CategoryType
            print(signInUrl)
            let parms : [String:Any] = ["userID" : id]
            print(parms)
            AFWrapperClass.requestPOSTURL(signInUrl, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.listingArray.removeAll()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["category_details"] as? [[String:Any]]{
                        for obj in allData{
                            self.listingArray.append(CategoryList(title: obj["name"] as? String ?? "", catId: obj["c_id"] as? String ?? ""))
                            
                        }
                    }
                    self.picker.reloadAllComponents()
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
        
    }
    
    
    func addLink() {
        let id = UserDefaults.standard.value(forKey: "id") ?? ""
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            IJProgressView.shared.showProgressView()
            let url = Constant.shared.baseUrl + Constant.shared.Addlink
            print(url)
            var parms = [String:Any]()
            if selectTypeTxtFld.text == "Live Stream" || selectTypeTxtFld.text == "Bible Study" {
                parms = ["user_id" : id,"title" : titleTxtFld.text ?? "","selectType" : selectedValue ,"link" : addlinkTxtFld.text ?? "", "description" : descriptionTxtView.text ?? "","image" : base64]
                print(parms)
            }else{
                parms = ["user_id" : id,"title" : titleTxtFld.text ?? "","selectType" : selectedValue , "description" : descriptionTxtView.text ?? "","image" : base64]
                print(parms)
            }
            AFWrapperClass.requestPOSTURL(url, params: parms, success: { (response) in
                IJProgressView.shared.hideProgressView()
                self.message = response["message"] as? String ?? ""
                let status = response["status"] as? Int
                if status == 1{
                    if let allData = response["userDetails"] as? [String:Any] {
                        print(allData)
                        IJProgressView.shared.hideProgressView()
                    }
                    showAlertMessage(title: Constant.shared.appTitle, message: self.message, okButton: "Ok", controller: self) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    IJProgressView.shared.hideProgressView()
                    alert(Constant.shared.appTitle, message: self.message, view: self)
                }
            }) { (error) in
                IJProgressView.shared.hideProgressView()
                alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
                print(error)
            }
            
        } else {
            print("Internet connection FAILED")
            alert(Constant.shared.appTitle, message: "Check internet connection", view: self)
        }
    }
    
    //MARK:-->    Upload Images
    
    func showActionSheet(){
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetController: UIAlertController = UIAlertController(title: NSLocalizedString("Upload Image", comment: ""), message: nil, preferredStyle: .actionSheet)
        actionSheetController.view.tintColor = UIColor.black
        let cancelActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Take Photo", comment: ""), style: .default)
        { action -> Void in
            self.openCamera()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton: UIAlertAction = UIAlertAction(title: NSLocalizedString("Choose From Gallery", comment: ""), style: .default)
        { action -> Void in
            self.gallery()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func gallery()
    {
        
        let myPickerControllerGallery = UIImagePickerController()
        myPickerControllerGallery.delegate = self
        myPickerControllerGallery.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerControllerGallery.allowsEditing = true
        self.present(myPickerControllerGallery, animated: true, completion: nil)
        
    }
    
    
    //MARK:- ***************  UIImagePickerController delegate Methods ****************
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        guard let image = info[UIImagePickerController.InfoKey.originalImage]
        guard let image = info[UIImagePickerController.InfoKey.editedImage]
                as? UIImage else {
            return
        }
        //        let imgData3 = image.jpegData(compressionQuality: 0.4)
        self.showUploadImage.contentMode = .scaleToFill
        self.showUploadImage.image = image
        self.showUploadImage.contentMode = .scaleAspectFill
        guard let imgData3 = image.jpegData(compressionQuality: 0.2) else {return}
        base64 = imgData3.base64EncodedString(options: .lineLength64Characters)
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker = UIImagePickerController()
        dismiss(animated: true, completion: nil)
    }
}

extension AddLinkVC: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        self.showUploadImage.image = image
    }
}


struct CategoryList {
    var title : String
    var catId : String
    
    init(title : String ,catId : String) {
        self.title = title
        self.catId = catId
    }
}


extension String {
    var verifyUrl: Bool {
        get {
            let url = URL(string: self)

            if url == nil || NSData(contentsOf: url!) == nil {
                return false
            } else {
                return true
            }
        }
    }
}
