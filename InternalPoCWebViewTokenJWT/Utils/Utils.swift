//
//  Utils.swift
//  InternalPoCWebViewTokenJWT
//
//  Created by TECDATA ENGINEERING on 29/3/23.
//

import Foundation
import WebKit

class Utils{
    
    static let shared = Utils()
    
    func clearCache() {
        if #available(iOS 9.0, *) {
            let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date as Date, completionHandler:{ })
        } else {
            var libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, false).first!
            libraryPath += "/Cookies"
            do {
                try FileManager.default.removeItem(atPath: libraryPath)
            } catch {
                print("error")
            }
            URLCache.shared.removeAllCachedResponses()
        }
    }
    
    struct Constants {
        // Url's PRO -> http://sfcdwcs01/ss/Satellite?d=&pagename=AppNWLogin&idCliente=022692392V&canal=WMO
        static let username = "022692392V"
        static let password = "Ao14022022"
        static let urlLab = "https://sfcdwcs01/ss/Satellite?d=&pagename=AppNWLogin&idCliente=09143714H&canal=APP"
        static let urlposicionglobal = "https://www.pass.carrefour.es/zona-cliente/posicion-global/?beta=true"
        static let urlDirect = "https://www.dev-pass.carrefour.es/solicitar-dinero"
        static let urlPRO = "https://www.dev-pass.carrefour.es/cs/Satellite?d=&pagename=AppNWLogin&idCliente=09143714H&canal=APP"
        static let tokenJWT = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlJFUTBNVVE1TjBOQ1JUSkVNemszTTBVMVJrTkRRMFUwUTBNMVJFRkJSamhETWpkRU5VRkJRZyJ9.eyJpc3MiOiJodHRwczovL2ZpZG0uZ2lneWEuY29tL2p3dC8zX3o3alBycDZNb3BoSUdGTmtVT3pDcnh6OXNWU2hfbGZpSWwtS09TZENTN1A1bTBsMVNiQmNlZ0VFRjdxQWtzU1gvIiwiYXBpS2V5IjoiM196N2pQcnA2TW9waElHRk5rVU96Q3J4ejlzVlNoX2xmaUlsLUtPU2RDUzdQNW0wbDFTYkJjZWdFRUY3cUFrc1NYIiwiaWF0IjoxNjg0NzcxNjg1LCJleHAiOjE2ODQ3NzE5ODUsInN1YiI6IjZmNjk0YmQwLWE5ZmMtNDAwNi05MzgzLTdmMTUyZTk5ZGEwNCIsInByb2ZpbGUudXNlcm5hbWUiOiIwOTE0MzcxNEgifQ.YkLLtUvzFB7k9Gd_JYlaBh_N_M-Rx2ZwJL4p_98zv8M8pTeiuHmbVkSg_b0QBwtN5sRUBOnPLDTqiH2D70o6tob8357aMawkba8FSVhqn55cgxwCKN6_HChfiGHjpytiYUfo3EJbTyUI-G0bChk5gnOutViGN1MAdZ77DMhbkspwqUwBdNy71rbZWCMS6Bqbqavh9D5wwoLzxSUZTc4Fu0wyvDtSRHrUmdQzQWKD6Mh5h18VvinOrL28_5gfEaLgZv0st9rDMAHTVo4ogJgNxv7z29HvL3W4F9zhvlASHrSd00it2ZVKeDdXINAZTilRgPqjxbGkCTdg_NB9sQnDdg"
    }
    
    func setupWebView(myWebViewContainer: UIView) -> WKWebView{
        var auxiliar = WKWebView()
        let userContentController = WKUserContentController()
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            let script = getJSCookiesString(for: cookies)
            let cookieScript = WKUserScript(source: script, injectionTime: .atDocumentStart, forMainFrameOnly: false)
            userContentController.addUserScript(cookieScript)
        }
        
        let webViewConfig = WKWebViewConfiguration()
        webViewConfig.allowsInlineMediaPlayback = true
        webViewConfig.applicationNameForUserAgent = "Safari/605.1.15"
        webViewConfig.userContentController = userContentController

        auxiliar = WKWebView(frame: myWebViewContainer.bounds, configuration: webViewConfig)
        return auxiliar
    }
    
    ///Generates script to create given cookies
    func getJSCookiesString(for cookies: [HTTPCookie]) -> String {
        var result = ""
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"

        for cookie in cookies {
            result += "document.cookie='\(cookie.name)=\(cookie.value); domain=\(cookie.domain); path=\(cookie.path); "
            if let date = cookie.expiresDate {
                result += "expires=\(dateFormatter.string(from: date)); "
            }
            if (cookie.isSecure) {
                result += "secure; "
            }
            result += "'; "
        }
        return result
    }
    
    
}
