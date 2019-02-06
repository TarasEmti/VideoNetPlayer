//
//  UIAlertController+Ext.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 04/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func showOkAlert(title: String?, message: String, okAction: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: .default, handler: okAction)
        alert.addAction(okAction)
        alert.show()
    }
    
    func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = UIViewController()
        let topWindow = UIApplication.shared.windows.last!
        window.windowLevel = topWindow.windowLevel + 1
        window.makeKeyAndVisible()
        window.rootViewController?.present(self, animated: true, completion: nil)
    }
}
