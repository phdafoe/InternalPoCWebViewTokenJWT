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
        static let usernameUint8:[UInt8] = [1,2,3,4,5,6,7,8,9,0]
        static let password = "Ao14022022"
        static let urlZonaPublica = "https://sfc-digital-b2b-b2c-dev.npapps.gkesf.es.wcorp.carrefour.com/mic4-home/"
        static let urlLibertoAnticiparPagos = "https://carrefourpagofacil.es/#/pay-process-direct/044P0d7r3s8g1j4q6i3U6W9C9Y4Y6g8Q3j7T7B6Z6u9OC"
        static let urlAplazarCompras = "https://sfc-digital-b2b-b2c-pro.apps.gkesf.es.wcorp.carrefour.com/zona-cliente/configuracion/aplazar-compras?card=50071147722401"
        static let urlposicionglobal = "https://sfc-digital-b2b-b2c-cua.npapps.gkesf.es.wcorp.carrefour.com/zona-cliente/posicion-global"
        static let urlDirect = "https://sfc-digital-b2b-b2c-pro.apps.gkesf.es.wcorp.carrefour.com/zona-cliente/configuracion/direct?card=50071147722401"
        static let urlPRO = "https://www.dev-pass.carrefour.es/cs/Satellite?d=&pagename=AppNWLogin&idCliente=09143714H&canal=APP"
        static let tokenJWT = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlJFUTBNVVE1TjBOQ1JUSkVNemszTTBVMVJrTkRRMFUwUTBNMVJFRkJSamhETWpkRU5VRkJRZyJ9.eyJpc3MiOiJodHRwczovL2ZpZG0uZ2lneWEuY29tL2p3dC8zX2RybmdJQkVjeW00OHZVSHlOcDJHS2Q2MDE3cGZvbmhhblRCREhWd0hOR3RYcG0tLVBSZ3pUZnEzZm5PNDB3WlcvIiwiYXBpS2V5IjoiM19kcm5nSUJFY3ltNDh2VUh5TnAyR0tkNjAxN3Bmb25oYW5UQkRIVndITkd0WHBtLS1QUmd6VGZxM2ZuTzQwd1pXIiwiaWF0IjoxNjkyNzgzMTczLCJleHAiOjE2OTI4MTkxNzMsInN1YiI6ImIwZWEwNjZhNzNjMTRmODk4NDI4YzhlYWQzMzQ4Y2NjIiwiZGF0YS5HUiI6Ik1ZQTBiZDViMjEiLCJwcm9maWxlLmVtYWlsIjoicGhkYWZvZUBnbWFpbC5jb20iLCJkYXRhLkRRIjoidHJ1ZSIsImRhdGEuYWNjZXB0ZWRDdXN0b21lclBvbGljaWVzIjp0cnVlLCJwcm9maWxlLnVzZXJuYW1lIjoiMDkxNDM3MTRIIn0.X1SMFFfFIZGXXTCG3Dc_TPB-ph365Rs03-DM1DjGy2CR5Lyloe2LW8K_6MHSMzqHJ7TCAi4a9vpGlq7lYZwiGcB1dqdDYghq3AS-vYvdC6fX0wlAG2xH-5PIitCqcb-6F8syy1uLEtiFjkcm9wd-ybeqwspOfPhk1vylDzRy53EL4b_s1BJQ5zAk4ioU6PQe-6-_pcKZRyMpyqIM4LFGezvY-dJW8nlsLlkCXWPixDeeBNmA-2pakwg_JdgbR9JsLHZrgtQGYQYB6bHdc65Z7E_ZXSPXF4HDz0oFZgb3mue2hTCKdYgOdCYajD5BNdxEtFtqaYoo2tSv6KX5TIGQDg"
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
