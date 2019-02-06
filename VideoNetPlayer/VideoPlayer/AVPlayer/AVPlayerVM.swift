//
//  AVPlayerVM.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 06/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import RxCocoa
import RxSwift
import AVKit

class AVPlayerVM {
    let videoUrl: BehaviorRelay<URL?> = BehaviorRelay(value: nil)
    let videoItem: BehaviorRelay<AVPlayerItem?> = BehaviorRelay(value: nil)
    let videoName: BehaviorRelay<String> = BehaviorRelay(value: "")
    let videoDuration: BehaviorRelay<String> = BehaviorRelay(value: "--:--")
    
    let disposeBag = DisposeBag()
    
    init() {
        videoUrl.asObservable().subscribe(onNext: { [weak self] (url) in
            if let url = url {
                let playerItem = AVPlayerItem(url: url)
                if playerItem.asset.duration.seconds > 0 {
                    self?.videoItem.accept(playerItem)
                } else {
                    DiskStorage.shared.deleteFile(at: url)
                    ErrorHandler.handleError(message: "Bad video format".localized)
                }
            }
        }).disposed(by: disposeBag)
        
        videoItem.asObservable().subscribe(onNext: { [weak self] (item) in
            guard let this = self else { return }
            if let item = item,
                let name = this.videoUrl.value?.lastPathComponent {
                this.videoName.accept(String(format: "\t%@", name))
                this.videoDuration.accept(item.asset.duration.toString())
            }
        }).disposed(by: disposeBag)
    }
}
