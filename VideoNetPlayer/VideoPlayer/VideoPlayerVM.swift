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
    
    let downloadService: DownloadServicability
    
    let videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let disposeBag = DisposeBag()
    
    init(videoLink: String? = nil, downloadService: DownloadServicability = DownloadService()) {
        self.videoLink = videoLink
        self.downloadService = downloadService
    }
    
    func uploadVideo(from url: URL) {
        if let localUrl = DiskStorage.shared.storageUrlForVideo(downloadURL: url) {
            videoUrl.accept(localUrl)
        } else {
            videoUrl.accept(url)
            downloadService.downloadData(from: url)
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { (data) in
                    do {
                        let localUrl = try DiskStorage.shared.cacheVideo(data: data,
                                                                         name: url.lastPathComponent)
                        print("New video at: \(localUrl.path)")
                    } catch {
                        ErrorHandler.handle(error: error)
                    }
                }, onError: { error in
                    ErrorHandler.handle(error: error)
                }).disposed(by: disposeBag)
        }
    }
}
