//
//  DirectViewController.swift
//  InternalPoCWebViewTokenJWT
//
//  Created by TECDATA ENGINEERING on 29/3/23.
//

import UIKit
import WebKit

class DirectViewController: UIViewController {
    
    // MARK: - Variables
    private var request : URLRequest {
        let baseUrl = Utils.Constants.urlposicionglobal
        let myURL = URL(string: baseUrl)!
        return URLRequest(url: myURL)
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var containerView: UIView!
    var myWebView: WKWebView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Clear cache
        Utils.shared.clearCache()
        self.myActivityIndicator.isHidden = true
        //print(Obfuscator().bytesByObfuscatingString(string: Utils.Constants.tokenJWT))
        // WebView + Delegate
        
        
        let webConfiguration = WKWebViewConfiguration()
            webConfiguration.allowsInlineMediaPlayback = true
            webConfiguration.applicationNameForUserAgent = "Safari/605.1.15"
        
        self.myWebView = WKWebView(frame: containerView.frame, configuration: webConfiguration)
        
        let cookie = HTTPCookie(properties: [
            .domain: "www.pass.carrefour.es",
            .path: "/",
            .name: "jwtToken",
            .value: "\(Utils.Constants.tokenJWT)",
            .secure: "TRUE",
            .expires: NSDate(timeIntervalSinceNow: 31556926),
        ])!
        
        self.myWebView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
            self.myWebView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in

                self.containerView.addSubview(self.myWebView)
                self.myWebView.translatesAutoresizingMaskIntoConstraints = false
                
                //constrains for the webview to fit the containerView
                let constraints = [
                    self.myWebView.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
                    self.myWebView.centerYAnchor.constraint(equalTo: self.containerView.centerYAnchor),
                    self.myWebView.widthAnchor.constraint(equalTo: self.containerView.widthAnchor),
                    self.myWebView.heightAnchor.constraint(equalTo: self.containerView.heightAnchor)
                ]
                
                //activate the constrains and load the url
                NSLayoutConstraint.activate(constraints)
                self.myWebView.navigationDelegate = self
                self.loadWebView()
            }
        }
    }


    private func loadWebView(tokenJWT: String? = nil){
        if let theWebView = myWebView {
            var urlRequest = self.request
            urlRequest.httpMethod = "GET"
            DispatchQueue.main.async {
                theWebView.load(urlRequest)
            }
        }
    }
    
    
    private func showActivityIndicator(show: Bool) {
        if show{
            self.myActivityIndicator.isHidden = false
            self.myActivityIndicator.startAnimating()
        } else {
            self.myActivityIndicator.isHidden = true
            self.myActivityIndicator.stopAnimating()
        }
    }

}

// MARK: - VideoIdViewController: WKNavigationDelegate
extension DirectViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)

            
    }

    func webView(_ webView: WKWebView,
                 didReceive challenge: URLAuthenticationChallenge,
                 completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        DispatchQueue.main.async {
            let exceptions = SecTrustCopyExceptions(serverTrust)
            SecTrustSetExceptions(serverTrust, exceptions)
            completionHandler(.useCredential, URLCredential(trust: serverTrust));
        }
        
    }
    
}
