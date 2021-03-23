//
//  AboutUSVC.swift
//  Restored Glory Christian Center
//
//  Created by Apple on 23/03/21.
//

import UIKit
import WebKit
import LGSideMenuController

class AboutUSVC: UIViewController ,WKNavigationDelegate{
    
    @IBOutlet weak var openUrl: WKWebView!
    @IBOutlet weak var menuButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "http://restoredglory.org/about-us/")!
        let urlRequest = URLRequest(url: url)
        openUrl.load(urlRequest)
        openUrl.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(openUrl)
        IJProgressView.shared.showProgressView()
        openUrl.navigationDelegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openMenu(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        IJProgressView.shared.hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        IJProgressView.shared.hideProgressView()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error){
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        IJProgressView.shared.hideProgressView()
    }
    
}
