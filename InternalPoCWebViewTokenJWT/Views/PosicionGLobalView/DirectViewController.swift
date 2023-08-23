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
        let baseUrl = Utils.Constants.urlDirect
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
        
        let webConfiguration = WKWebViewConfiguration()
            webConfiguration.allowsInlineMediaPlayback = true
            webConfiguration.applicationNameForUserAgent = "Safari/605.1.15, canal:MIC4"
        
        self.myWebView = WKWebView(frame: containerView.frame, configuration: webConfiguration)
    
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


    private func loadWebView(tokenJWT: String? = nil){
        if let theWebView = myWebView {
            var urlRequest = self.request
            urlRequest.httpMethod = "GET"
            urlRequest.setValue("es", forHTTPHeaderField: "u_country")
            urlRequest.setValue("MYA0bd5b21", forHTTPHeaderField: "u_id")
            urlRequest.setValue("500711477224", forHTTPHeaderField: "u_sfc")
            urlRequest.setValue("200", forHTTPHeaderField: "syatem_http_status")
            urlRequest.setValue("app", forHTTPHeaderField: "p_channel")
            urlRequest.setValue("logged", forHTTPHeaderField: "p_login_status")
            urlRequest.setValue("financial_services", forHTTPHeaderField: "p_site_business_unit")
            urlRequest.setValue("true", forHTTPHeaderField: "p_integrated")
            urlRequest.setValue("jwtToken=\(Utils.Constants.tokenJWT)", forHTTPHeaderField: "Cookie")
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
        debugPrint("Request_Navigation\(navigationAction.request.url?.absoluteString)")
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
        debugPrint("Response_Navigation\(navigationResponse.response.url?.absoluteString)")

            
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
