//
//  WikiWebViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 30.09.2021.
//

import UIKit
import WebKit

class WikiWebVC: UIViewController, WKNavigationDelegate {
    var webView = WKWebView()
    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        loadingIndicator.isAnimating = true
    }
    
    let loadingIndicator: ProgressView = {
        let loadingView = ProgressView(colors: [.systemMint, .systemGreen,], lineWidth: 5)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view = webView
        loadingIndicator.isAnimating = false
    }
}
