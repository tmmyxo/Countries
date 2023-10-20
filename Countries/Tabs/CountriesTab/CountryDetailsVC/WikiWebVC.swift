//
//  WikiWebViewController.swift
//  Milestone Project 5 CountryList
//
//  Created by Artem Dolbiev on 30.09.2021.
//

import UIKit
import WebKit

class WikiWebVC: UIViewController {

    private var webView = WKWebView()
    private var url: URL?

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        return loadingView
    }()

    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(loadingIndicator)
        webView.navigationDelegate = self
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        loadURL(url)
    }

    override func viewDidLayoutSubviews() {
        loadingIndicator.startAnimating()
    }

    // MARK: Constraints setup
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            loadingIndicator.widthAnchor.constraint(equalToConstant: 50),
            loadingIndicator.heightAnchor.constraint(equalTo: self.loadingIndicator.widthAnchor)
        ])
    }

    private func loadURL(_ url: URL?) {
        guard let url = url else {
            self.displayNotificationToUser(title: String(localized: "Invalid URL"), text: "", prefferedStyle: .alert) { _ in
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        webView.load(URLRequest(url: url))
    }
}

extension WikiWebVC: WKNavigationDelegate {

    // MARK: WKNavigation Delegate methods
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingIndicator.removeFromSuperview()
        view = webView
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.displayNotificationToUser(title: String(localized: "Error"), text: "\(error.localizedDescription)", prefferedStyle: .alert) { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.displayNotificationToUser(title: String(localized: "Error"), text: "\(error.localizedDescription)", prefferedStyle: .alert) { _ in
            self.dismiss(animated: true)
        }
    }
}
