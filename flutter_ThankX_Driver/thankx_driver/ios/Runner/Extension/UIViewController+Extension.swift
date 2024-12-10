//
//  UIViewController+Extension.swift
//  DemoAppStoryboard
//
//  Created by agileimac-1 on 21/10/19.
//  Copyright © 2019 Agile Infoways. All rights reserved.
//

import Foundation
import UIKit


//MARK:- UIViewController
extension UIViewController {
    class func topMostViewController() -> UIViewController! {
        if #available(iOS 13, *) {
            let keyWindow = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first
            return self.topViewController(controller: keyWindow?.rootViewController)!
        } else {
            return self.topViewController(controller: UIApplication.shared.keyWindow?.rootViewController)!
        }
    }
    
    private class func topViewController(controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
