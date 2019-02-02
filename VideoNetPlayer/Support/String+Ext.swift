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
        if let url = URL(string: self) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
    
    func isValidVideoURL() -> Bool {
        if self.isValidURL() {
            let videoFormatPrefix = [".mp4", ".mov", ".flv"]
            for prefix in videoFormatPrefix {
                if self.hasPrefix(prefix) {
                    return true
                }
            }
        }
        return false
    }
}
