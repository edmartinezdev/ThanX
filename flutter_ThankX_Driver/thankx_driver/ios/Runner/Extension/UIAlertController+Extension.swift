//
//  UIAlertController+Extension.swift
//  DemoAppStoryboard
//
//  Created by agileimac-1 on 21/10/19.
//  Copyright © 2019 Agile Infoways. All rights reserved.
//

import Foundation
import UIKit

struct Localization {
    static let btnCancel = "CANCEL"
    static let btnOK = "OK"
    static let AppName = "Location Tracking"
    static let msgAskToEnableLocationservice = "Requires your location for better use. Your location services are DISABLED. Would you like to enable it for a better user experience?."
    static let msgRedicrectToSetting = "You will be now transferred to the APP SETTINGS - please select PRIVACY/LOCATION and enable 'while using app'."
}


extension UIAlertController {
    

    
    static func displayAlertWithMessage(title: String = Localization.AppName ,message strMessage: String) {
        UIAlertController.displayAlertFromController(withTitle: title, withmessage: strMessage, otherButtonTitles: ["OK"], completionHandler: nil)
    }
    
    //MARK:- displayAlertFromController
    static func displayAlertFromController(viewController: UIViewController = UIViewController.topMostViewController(),
                                           withTitle title:String?,
                                           withmessage message:String?,
                                           otherButtonTitles otherTitles:[String]?,
                                           isNeedToHighLightCancelButton isHighLighted: Bool = true,
                                           completionHandler : ((_ index : NSInteger) -> Void)?) {
        
        // Resign inout
        UIViewController.topMostViewController().view.endEditing(true)
        
        if viewController.presentedViewController is UIAlertController {
            let lastalert = viewController.presentedViewController as! UIAlertController
            lastalert.dismiss(animated: false, completion: nil)
        }
        
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        for indexpos in (0...(otherTitles?.count)! - 1) {
            let  strbtntitle = otherTitles![indexpos] as String
            var style: UIAlertAction.Style = .default
            if (strbtntitle as NSString).isEqual(to: "Cancel") && isHighLighted {
                style = .cancel
            }
            else if (strbtntitle as NSString).isEqual(to: "Delete") && isHighLighted {
                style = .destructive
            }
            
            let action : UIAlertAction = UIAlertAction(title: strbtntitle as String, style: style, handler: { (action1 : UIAlertAction) in
                if (completionHandler != nil) {
                    completionHandler!(indexpos)
                }
            })
            alert.addAction(action)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}

