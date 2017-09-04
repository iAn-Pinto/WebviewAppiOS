//
//  ViewController.swift
//  CirtruWebview
//
//  Created by Ian Pinto on 05/06/17.
//  Copyright © 2017 Cirtru. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

//    @IBOutlet weak var cirtruWebView: UIWebView!
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let url = URL(string: "https://www.cirtru.com/")
//        if let unwrappedURL = url {
//            
//            let request = URLRequest(url: unwrappedURL)
//            let session = URLSession.shared
//            
//            let task = session.dataTask(with: request) { (data, response, error) in
//                
//                if error == nil {
//                    
//                    self.cirtruWebView.loadRequest(request)
//                    
//                } else {
//                    
//                    print("ERROR: \(error)")
//                    
//                }
//                
//            }
//            
//            task.resume()
//            
//        }
        
        // Create WKWebView in code, because IB cannot add a WKWebView directly
        webView = WKWebView()
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[webView]|",
                                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil,
                                                                           views: ["webView": webView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[webView]-|",
                                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil,
                                                                           views: ["webView": webView]))
        
        // 2 ways to load webpage: `loadHTML()` or `loadURL()`
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
        let userAgentValue = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/603.2.4 (KHTML, like Gecko) Version/10.1.1 Safari/603.2.4"
        webView.customUserAgent = userAgentValue
        loadURL()
    }
    
    func loadURL() {
        let urlString = "https://www.cirtru.com/"
        let url = URL(string: urlString)
                if let unwrappedURL = url {
        
                    let request = URLRequest(url: unwrappedURL)
                    let session = URLSession.shared
        
                    let task = session.dataTask(with: request) { (data, response, error) in
        
                        if error == nil {
        
                            self.webView.load(request)
        
                        } else {
        
                            print("ERROR: \(error)")
        
                        }
                        
                    }
                    
                    task.resume()
                    
                }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        
//            decisionHandler(.allow)
//    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }

    // JS alert box
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (() -> Void)) {
        
        let alertController = UIAlertController(title: "Notice", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // JS confirm box.
    // Display alertView through UIAlertController instead of JS popup
    // You don't need to write confirm logic. It's for the webpage.
    // ref : https://github.com/qmihara/WebKitDemo/blob/master/WebKitDemo/WebViewController.swift
    
    func webView(webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        #if DEBUG
            
            print("JAVA Script Confirm")
            
        #endif
        
        let alertController = UIAlertController(title: webView.url?.host, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            completionHandler(false)
        }))
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            completionHandler(true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }

}

