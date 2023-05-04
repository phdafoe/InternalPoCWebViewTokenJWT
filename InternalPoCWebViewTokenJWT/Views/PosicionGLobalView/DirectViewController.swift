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
        let baseUrl = Utils.Constants.urlPRO
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
        self.containerView.addSubview(self.myWebView)
        self.myWebView.translatesAutoresizingMaskIntoConstraints = false
        
        //constrains for the webview to fit the containerView
        let constraints = [
            self.myWebView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            self.myWebView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            self.myWebView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            self.myWebView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ]
        
        //activate the constrains and load the url
        NSLayoutConstraint.activate(constraints)
        myWebView.navigationDelegate = self
        self.loadWebView(tokenJWT: Utils.Constants.tokenJWT)
    }


    private func loadWebView(tokenJWT: String){
        if let theWebView = myWebView {
            var urlRequest = self.request
            //urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenJWT)"]
            //urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
            //urlRequest.allHTTPHeaderFields = ["canal": "MIC4"]
            urlRequest.httpMethod = "GET"
            DispatchQueue.main.async {
                theWebView.load(urlRequest)
            }
        }
    }
    
    private func loadGlobalPosition() {
        let baseUrl = Utils.Constants.urlposicionglobal
        let myURL = URL(string: baseUrl)!
        var myUrlRequest = URLRequest(url: myURL)
        //urlRequest.allHTTPHeaderFields = ["Authorization": "Bearer \(tokenJWT)"]
        //urlRequest.allHTTPHeaderFields = ["Content-Type": "application/json"]
        //urlRequest.allHTTPHeaderFields = ["canal": "MIC4"]
        myUrlRequest.httpMethod = "GET"
        myUrlRequest.httpShouldHandleCookies = true
        if let theWebView = myWebView {
            DispatchQueue.main.async {
                theWebView.load(myUrlRequest)
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
        debugPrint("didStartProvisionalNavigation: ")
        self.showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debugPrint("didFinish navigation: ")
        self.showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
        debugPrint("REQUEST NAVIGATION: "+(navigationAction.request.url?.absoluteString ?? ""))
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        debugPrint("RESPONSE: "+(navigationResponse.response.url?.absoluteString ?? ""))
        
        guard let NwLogin = navigationResponse.response.url?.absoluteString.contains("pagename=AppNWLogin") else { return }
        
        if NwLogin{
            self.loadGlobalPosition()
        }
            
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
