//
//  BaseConnectivity.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 19/04/22.
//

import Foundation
import Alamofire

class BaseConnectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    class func isConnectedToInternetWithToast() -> Bool {
        let status = NetworkReachabilityManager()?.isReachable ?? false
        if !status {
//            ISMessages.show(App.Message.internetConnectionMessage)
        }
        return status
    }
}
