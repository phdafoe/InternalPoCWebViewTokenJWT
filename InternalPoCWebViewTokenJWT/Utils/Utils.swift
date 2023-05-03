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
        static let username = "022692392V" // Este idClient debe tener le formato CETELEM
        static let password = "Ao14022022"
        static let urlLab = "https://sfcdwcs01/ss/Satellite?d=&pagename=AppNWLogin&idCliente=022692392V&canal=MIC4"
        static let urlPRO = "https://www.pass.carrefour.es/solicitar-dinero"
        static let tokenJWT = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IlJFUTBNVVE1TjBOQ1JUSkVNemszTTBVMVJrTkRRMFUwUTBNMVJFRkJSamhETWpkRU5VRkJRZyJ9.eyJpc3MiOiJodHRwczovL2ZpZG0uZ2lneWEuY29tL2p3dC8zXzhSX1lweGZocXFKRDRFeDFiZ24yOGxtTUV1eUQzd1MtYWc0Yl9xSnRMcFhJTVJPdHZtRjZIQXRPRzRXN1ZyNjUvIiwiYXBpS2V5IjoiM184Ul9ZcHhmaHFxSkQ0RXgxYmduMjhsbU1FdXlEM3dTLWFnNGJfcUp0THBYSU1ST3R2bUY2SEF0T0c0VzdWcjY1IiwiaWF0IjoxNjgwMTcwMzE0LCJleHAiOjE2ODAxNzA2MTQsInN1YiI6IjZmNjk0YmQwLWE5ZmMtNDAwNi05MzgzLTdmMTUyZTk5ZGEwNCIsInByb2ZpbGUudXNlcm5hbWUiOiIwOTE0MzcxNEgifQ.GGjWVv_8JcvVQfgTkeabYoH73blng0C3td-4AdLPgTdbEbs3q_dhBf45y04bUmUH9D-f44J0dqeFeMCzDCjf-hc3FnL-mHB6bZXLrTvjBdUwAdQCF-oCwrwQ0sHD2_TcivVIG2SzNRgGY6_XolGQ8w-k_KDkAiU9LYZ9VTn9axBaQixqKMEXmjGSlW8a95hvMgvACWupdPqGdWS_iGfhPYi-VbOkLfZP9P0BL2TScF6ZHvdLTxUq0fqMczJe6okbosk5vbY6cyCZGOO8VMCpcce5GCx38x9tOiqKcaS9nm-TnW1WMjJt_PShcddMnxoCYy4t6YR5jhnKVLW2-miP7A"
    }
    
    
}
