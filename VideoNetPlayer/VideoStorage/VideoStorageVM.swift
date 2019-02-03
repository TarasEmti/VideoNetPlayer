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
    private let videoFiles: [URL]
    
    init() {
        let files: [URL]
        do {
            let dirUrl = DiskManager.shared.tempVideoFolder
            let allFiles = try FileManager.default.contentsOfDirectory(at: dirUrl, includingPropertiesForKeys: [])
            files = allFiles.filter({$0.pathExtension == "mp4"})
        } catch {
            print(error)
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
}
