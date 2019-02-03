//
//  DiskManager.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 03/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import Foundation

class DiskManager {
    
    static let shared = DiskManager()
    
    private init() {}
    
    var tempVideoFolder: String {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("/alohaVideos")
        return url.path
    }
    
    func saveVideo(data: Data, pathExtension: String) throws -> URL {
        do {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd_HH-mm-ss"
            let videoName = String(format: "tempVideo-%@.%@", df.string(from: Date()), pathExtension)
            let videoUrl = FileManager.default.temporaryDirectory.appendingPathComponent(videoName)
            try data.write(to: videoUrl)
            print("New video at: \(videoUrl)")
            return videoUrl
        } catch {
            throw error
        }
    }
}
