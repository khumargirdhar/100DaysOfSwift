//
//  DetailViewController.swift
//  Project16
//
//  Created by Khumar Girdhar on 22/05/21.
//

import WebKit
import UIKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var website: String?
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: website!) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
}
