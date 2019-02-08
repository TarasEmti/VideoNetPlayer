//
//  DiskManager.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 03/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import Foundation
import UIKit

class DiskStorage {
    
    static let shared = DiskStorage()
    
    private init() {}
    
    var tempVideoFolder: URL {
        let url = try? FileManager.default.url(for: .cachesDirectory,
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
                ErrorHandler.handle(error: error)
            }
        }
        return alohaFolder
    }
    let supportedVideoExtensions: Set<String> = ["mp4", "mov", "m4v"]
    
    func cacheVideo(data: Data, name: String) throws -> URL {
        do {
            let videoUrl = tempVideoFolder.appendingPathComponent(name)
            try saveFile(at: videoUrl, fileData: data)
            print("New video at: \(videoUrl)")
            return videoUrl
        } catch {
            throw error
        }
    }
    
    func saveFile(at url: URL, fileData: Data) throws {
        do {
            try fileData.write(to: url)
        } catch {
            throw error
        }
    }
    
    func storageUrlForVideo(downloadURL url: URL) -> URL? {
        let videoPath = tempVideoFolder.appendingPathComponent(url.lastPathComponent)
        if FileManager.default.fileExists(atPath: videoPath.path) {
            return videoPath
        } else {
            return nil
        }
    }
    
    func deleteFile(at url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            ErrorHandler.handle(error: error)
        }
    }
}
