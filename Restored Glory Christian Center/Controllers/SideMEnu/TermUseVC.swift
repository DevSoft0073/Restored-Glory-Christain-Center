//
//  TermUseVC.swift
//  Restored Glory Christian Center
//
//  Created by Vivek Dharmani on 21/05/21.
//

import UIKit
import WebKit
import LGSideMenuController

class TermUseVC: UIViewController {

    @IBOutlet weak var openUrl: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = URL(string: "https://www.google.com/")!
//        let urlRequest = URLRequest(url: url)
//        openUrl.load(urlRequest)
//        openUrl.autoresizingMask = [.flexibleWidth ,.flexibleHeight]
//        view.addSubview(openUrl)
//        IJProgressView.shared.showProgressView()
//        openUrl.navigationDelegate = self
//        openUrl.allowsBackForwardNavigationGestures = true
//        openUrl.navigationDelegate = self
//        openUrl.uiDelegate = self
//        let url = NSURL(string: "https://www.google.com/")!
//                      let request = NSURLRequest(url: url as URL)
//                      openUrl.navigationDelegate = self
//         openUrl.load(request as URLRequest)
            let openUrl = WKWebView(frame: view.frame)
            openUrl.navigationDelegate = self
        
            view.addSubview(openUrl)

            let url = URL(string: "https://www.google.com")!
            openUrl.load(URLRequest(url: url))
            openUrl.allowsBackForwardNavigationGestures = true
//        openUrl.load(urlRequest)
//        openUrl.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        view.addSubview(openUrl)
        
    }
    
    @IBAction func sideButton(_ sender: Any) {
        sideMenuController?.showLeftViewAnimated()
    }
  
    

}
extension TermUseVC:WKNavigationDelegate{

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//   print( AFWrapperClass.svprogressHudShow(title: "Loading...", view: self))
        print("get1")
  }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//    AFWrapperClass.svprogressHudDismiss(view: self)
        print("get2")
        IJProgressView.shared.hideProgressView()
  }

    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
//    self.Alert(Title: AppName, message: error.localizedDescription)
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        IJProgressView.shared.hideProgressView()
        print("get3")
      }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        alert(Constant.shared.appTitle, message: error.localizedDescription, view: self)
        IJProgressView.shared.hideProgressView()
        print("get4")
    }
}
