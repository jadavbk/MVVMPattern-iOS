//
//  AppUtility.swift
//  MVVMPattern
//
//  Created by Bharat Jadav on 02/07/21.
//

import Foundation
import UIKit
import SwiftUI

class AppUtility: NSObject {
    static let shared = AppUtility()
    var fcmToken : String = ""
    
    public override init() {
        super.init()
        intialize()
    }
    func intialize() {
        //default initialize
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passWordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passWordRegEx)
        return passwordTest.evaluate(with: password)
    }
}

//MARK: - Set Print Option
extension AppUtility {
    func printToConsole(_ object : Any) {
        #if DEBUG
        Swift.print(object)
        #endif
    }
}

//MARK: - Gloabl Alert View
extension AppUtility {
    func showAlertWith(_ title:String, _ message:String, completion:@escaping(_ action:Bool?) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: UIAlertController.Style.alert
            )
            
            alert.addAction(UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: { action in
                    completion(true)
                }
            ))
            
            DispatchQueue.main.async {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getRootViewController() -> UIViewController? {
        return UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController
    }
}
