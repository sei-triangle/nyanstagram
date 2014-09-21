//
//  ViewController.swift
//  instagram-nyanchan22
//
//  Created by sei on 2014/09/20.
//  Copyright (c) 2014年 sei-triangle. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        request()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
        btnBack.enabled = webView.canGoBack
        
//        let script = "document.body.innerHTML"
        let script = "document.querySelector('div.Frame').getAttribute('src')"
        let html = webView.stringByEvaluatingJavaScriptFromString(script)
        if html != nil && html != "" {
//            println(html)
            downLoadImage(html!)
        }
    }
    
    func downLoadImage(imageUrl: String) {
//        let URL = NSURL(string: imageUrl)
//        let request = NSURLRequest(URL: URL)
//        imgView.setImageWithURL(URL)
//        let operation = AFImageRequestOperation.
//        webView2.loadRequest(request)
        
        let alert = UIAlertController(title: "画像保存", message: "画像を保存しますか？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "YES", style: .Default) { action in
            var manager = AFHTTPRequestOperationManager()
            manager.responseSerializer = AFImageResponseSerializer()
//            manager.GET(imageUrl, parameters: nil, success: {(o, i) -> in nil}, failure: nil)
            manager.GET(imageUrl, parameters: nil,
                success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    if let img : UIImage = responseObject as? UIImage {
                        UIImageWriteToSavedPhotosAlbum(img, self, nil, nil)
                    }
                },
                failure: nil)
        }
        alert.addAction(okAction)
        
        let noAction = UIAlertAction(title: "NO", style: .Default) { action in
            println("no")
        }
        alert.addAction(noAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }

    func request() {
        let con: UINavigationController = KINWebBrowserViewController.navigationControllerWithWebBrowser()
        self.presentViewController(con, animated: true, completion: nil)
        let URL = NSURL(string: "http://instagram.com/nyanchan22")
//        con.loadURL(URL)
//        self.navigationController!.pushViewController(con, animated: true)
        let browser = con.rootWebBrowserViewController()
        browser.loadURLString("http://instagram.com/nyanchan22")
        
        webView.scalesPageToFit = true
        webView.loadRequest(NSURLRequest(URL: URL))
    }
    
    @IBAction func tapBack(sender: AnyObject) {
        webView.goBack()
    }
    @IBAction func tapReload(sender: AnyObject) {
        webView.reload()
    }
}

