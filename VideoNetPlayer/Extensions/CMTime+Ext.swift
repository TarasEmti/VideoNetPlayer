//
//  CMTime+Ext.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 03/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import AVKit

extension CMTime {
    func toString() -> String {
        let length = self.seconds
        let hours = Int(length/3600)
        let minutes = Int((length - Double(hours)*3600)/60)
        let seconds = Int(length - Double(hours)*3600 - Double(minutes)*60)
        var time = ""
        if hours > 0 {
            time = "\(hours):"
        }
        time.append(String(format:"%02d:", minutes))
        time.append(String(format:"%02d", seconds))
        return time
    }
}
