//
//  VideoPlayerVM.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 31/01/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import RxCocoa
import RxSwift

class VideoPlayerVM {
    let downloadButtonText = "Upload".localized
    let cancelDownloadButtonText = "Cancel".localized
    let linkLabelText = "Enter video URL:".localized
    let urlTextFieldPlaceholder = "http://"
    
    var videoLink: String?
    
    let videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let disposeBag = DisposeBag()
    
    init(videoLink: String? = nil) {
        self.videoLink = videoLink
    }
    
    func uploadVideo(from url: URL) {
        if let localUrl = DiskStorage.shared.storageUrlForVideo(downloadURL: url) {
            videoUrl.accept(localUrl)
        } else {
            DownloadManager.shared.downloadData(from: url)
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { [weak self] (data) in
                    do {
                        let localUrl = try DiskStorage.shared.saveVideo(data: data,
                                                                        name: url.lastPathComponent)
                        self?.videoUrl.accept(localUrl)
                    } catch {
                        ErrorHandler.handle(error: error)
                    }
                }, onError: { error in
                    ErrorHandler.handle(error: error)
                }).disposed(by: disposeBag)
        }
    }
}
