//
//  ViewController.swift
//  sample_wkwebview
//
//  Created by Apple on 2017/10/28.
//  Copyright © 2017年 Apple. All rights reserved.
//

import UIKit
import WebKit // ブラウザ（WKWebView）に必要

class ViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    
    var webView = WKWebView()
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //WKWebViewConfigurationにuserscript追加
        let webViewConfiguration = WKWebViewConfiguration()
        let userController:WKUserContentController = WKUserContentController()
        //messageHandlersの名前を登録
        //addScriptMessageHandler() => add()に変わったみたいです。
        userController.add(self, name: "windowClose")
        //windowがloadされる前にjsを追加
        if let path = Bundle.main.path(forResource: "WindowClose", ofType: "js"){
            if let source = try? NSString(contentsOfFile: path, encoding: String.Encoding.utf8.rawValue){
                let userscript = WKUserScript(source: source as String,injectionTime:WKUserScriptInjectionTime.atDocumentEnd,forMainFrameOnly:true)
                userController.addUserScript(userscript)
            }
        }
        
        webViewConfiguration.userContentController = userController
        webView = WKWebView(frame: view.bounds, configuration: webViewConfiguration)
        
        // サイズを指定してブラウザ作成
        _ = WKWebView(frame: CGRect(x: 0, y: statusBarHeight, width: self.view.frame.width, height: self.view.frame.height - statusBarHeight))
        
        // ローカルのHTMLを読み込む
        if let htmlData = Bundle.main.path(forResource: "html/index", ofType: "html") {
            webView.load(URLRequest(url: URL(fileURLWithPath: htmlData)))
            // webView.
            webView.scrollView.bounces = false
            self.view.addSubview(webView)
        } else {
            print("file not found")
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        // addScriptMessageHandlerで指定したコールバック名を判断して処理を分岐させることができます
        
        if(message.name == "windowClose") {
            print("Window close")
            let array = message.body
            let array2 = (array as AnyObject).components(separatedBy:"|")
            
            if array2.count > 1 {
                
                let argv1 = array2[0]
                let argv2 = array2[1]
                
                if argv1 == "test" {
                    if argv2 == "hoge" {
                        webView.evaluateJavaScript("returnMessage('\(argv2)');", completionHandler: nil)
                        
                        
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
}
