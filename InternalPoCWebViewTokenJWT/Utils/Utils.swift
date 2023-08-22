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
        static let urlposicionglobal = "http://sfc-digital-b2b-b2c-pro.apps.gkesf.es.wcorp.carrefour.com/zona-cliente/posicion-global"
        static let urlDirect = "https://www.dev-pass.carrefour.es/solicitar-dinero"
        static let urlPRO = "https://www.dev-pass.carrefour.es/cs/Satellite?d=&pagename=AppNWLogin&idCliente=09143714H&canal=APP"
        static let tokenJWT = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlJFUTBNVVE1TjBOQ1JUSkVNemszTTBVMVJrTkRRMFUwUTBNMVJFRkJSamhETWpkRU5VRkJRZyJ9.eyJpc3MiOiJodHRwczovL2ZpZG0uZ2lneWEuY29tL2p3dC8zX3o3alBycDZNb3BoSUdGTmtVT3pDcnh6OXNWU2hfbGZpSWwtS09TZENTN1A1bTBsMVNiQmNlZ0VFRjdxQWtzU1gvIiwiYXBpS2V5IjoiM196N2pQcnA2TW9waElHRk5rVU96Q3J4ejlzVlNoX2xmaUlsLUtPU2RDUzdQNW0wbDFTYkJjZWdFRUY3cUFrc1NYIiwiaWF0IjoxNjkyMjAzMzIyLCJleHAiOjE2OTIyMDM2MjIsInN1YiI6IjZmNjk0YmQwLWE5ZmMtNDAwNi05MzgzLTdmMTUyZTk5ZGEwNCIsInByb2ZpbGUudXNlcm5hbWUiOiIwOTE0MzcxNEgifQ.bTYTGuSxXdcHOmEFHYItM_xmJWTttNd0oWLUfaup7YdDkSx_uN8_u79umHG6TjT_OS5YQwfVtjY6sWMOLIg_5bXzM_gqhMNR_rpvVDnwPSsj0QyUDo_kr1FoVax28iodpYz4IFU5LM4pdr0qizf_QXYn6vwEMNxoeO1wt9InmyeEjdna6R4CtzijqSSoULYiZWKybq7cU1dWLshL8dxeeCo22nikLgVDk8Mpw-5NObIkAcmbUqeNDdG2AzXTxZLpPDdonwWkvX_1_15NY5-sv4SL4GKKvIzWZni7_Vhvd9MTKcts2laB5dyh7abpfiD_7ep0euhjrNin8633bBgMxw"
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
