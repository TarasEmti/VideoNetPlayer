//
//  VideoStorageVM.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 03/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import Foundation
import RxCocoa

class VideoStorageVM {
    
    let chosenItem: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    private var videoFiles: [URL]
    
    init() {
        let files: [URL]
        do {
            let dirUrl = DiskStorage.shared.tempVideoFolder
            let allFiles = try FileManager.default.contentsOfDirectory(at: dirUrl, includingPropertiesForKeys: [])
            files = allFiles.filter({ file in
                for ext in DiskStorage.shared.supportedVideoExtensions {
                    if file.pathExtension == ext {
                        return true
                    }
                }
                return false
            })
        } catch {
            ErrorHandler.handle(error: error)
            files = []
        }
        videoFiles = files
    }
    
    var numberOfItems: Int {
        return videoFiles.count
    }
    
    func titleForCell(at: IndexPath) -> String {
        return videoFiles[at.row].lastPathComponent
    }
    
    func onSelect(at: IndexPath) {
        let video = videoFiles[at.row]
        chosenItem.accept(video)
    }
    
    func remove(at: IndexPath) {
        let file = videoFiles[at.row]
        DiskStorage.shared.deleteFile(at: file)
        videoFiles.remove(at: at.row)
    }
}
