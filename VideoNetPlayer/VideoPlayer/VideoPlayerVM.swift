//
//  VideoPlayerVM.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 31/01/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

class VideoPlayerVM {
    let downloadButtonText = "Download".localized
    let cancelDownloadButtonText = "Cancel".localized
    let linkLabelText = "Enter video URL:".localized
    let urlTextFieldPlaceholder = "http://"
    
    var videoLink: String?
    
    init(videoLink: String? = nil) {
        self.videoLink = videoLink
    }
}
