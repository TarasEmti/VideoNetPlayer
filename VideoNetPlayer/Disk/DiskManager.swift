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
    
    var tempVideoFolder: URL {
        let url = try? FileManager.default.url(for: .downloadsDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
        let alohaFolder = url!.appendingPathComponent("aloha")
        if !FileManager.default.fileExists(atPath: alohaFolder.path) {
            do {
            try FileManager.default.createDirectory(atPath: alohaFolder.relativePath,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)
            } catch {
                print(error)
            }
        }
        return alohaFolder
    }
    let supportedVideo = ["mp4", "mov", "m4v"]
    
    func saveVideo(data: Data, name: String) throws -> URL {
        do {
            let videoUrl = tempVideoFolder.appendingPathComponent(name)
            try data.write(to: videoUrl)
            print("New video at: \(videoUrl)")
            return videoUrl
        } catch {
            throw error
        }
    }
    
    func isVideoExist(downloadURL url: URL) -> URL? {
        let videoPath = tempVideoFolder.appendingPathComponent(url.lastPathComponent)
        if FileManager.default.fileExists(atPath: videoPath.path) {
            return videoPath
        } else {
            return nil
        }
    }
}
