//
//  ErrorHandler.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 06/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import UIKit


class ErrorHandler {
    private static let errorTitle = "Error".localized
    class func handle(error: Error) {
        var errorTitle = ErrorHandler.errorTitle
        if let downloadError = error as? DownloadError {
            if let code = downloadError.code {
                errorTitle += " \(code)"
            }
            UIAlertController.showOkAlert(title: errorTitle, message: downloadError.message.localized)
        } else {
            UIAlertController.showOkAlert(title: errorTitle, message: error.localizedDescription)
        }
    }
    
    class func handleError(message: String) {
        UIAlertController.showOkAlert(title: ErrorHandler.errorTitle, message: message)
    }
}
