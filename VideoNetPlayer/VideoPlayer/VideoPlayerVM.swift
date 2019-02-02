//
//  VideoPlayerVM.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 31/01/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import RxSwift

class VideoPlayerVM {
    let downloadButtonText = "Download"
    let cancelDownloadButtonText = "Cancel"
    let linkLabelText = "Enter video URL:"
    let urlTextFieldPlaceholder = "http://"
    
    var videoLink: String?
    
    init(videoLink: String? = nil) {
        self.videoLink = videoLink
    }
}
