//
//  String+Ext.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 02/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//
import Foundation
import UIKit

extension String {
    func isValidURL() -> Bool {
        if self.hasPrefix("http"), let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func isValidVideoURL() -> Bool {
        if self.isValidURL() {
            let videoFormatExt = DiskStorage.shared.supportedVideoExtensions
            for ext in videoFormatExt {
                if self.hasSuffix(".\(ext)") {
                    return true
                }
            }
        }
        return false
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
