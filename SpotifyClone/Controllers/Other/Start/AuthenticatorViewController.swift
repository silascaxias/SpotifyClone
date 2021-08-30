//
//  AuthenticatorViewController.swift
//  SpotifyClone
//
//  Created by Silas Da Silva Caxias on 12/08/21.
//

import UIKit
import WebKit

class AuthenticatorViewController: UIViewController {

    private let webView: WKWebView = {
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()
    
    public var signInDidCompleted: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        view.addSubview(webView)
        guard let url = AuthenticatorManager.shared.signInURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        webView.frame = view.bounds
    }

}

extension AuthenticatorViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if  let url = webView.url,
            let component = URLComponents(string: url.absoluteString),
            let queryItems = component.queryItems,
            let code = queryItems.first(where: { $0.name == "code" })?.value {
            
            webView.isHidden = true
            
            AuthenticatorManager.shared.fetchToken(with: code) { [weak self] result in
                DispatchQueue.main.async {
                    self?.navigationController?.popToRootViewController(animated: true)
                    self?.signInDidCompleted?(result)
                }
            }
        }
    }
}
