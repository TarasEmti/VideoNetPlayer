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
    let isLoadingAsset: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    let disposeBag = DisposeBag()
    
    private static let playableKey = "playable"
    
    init() {
        videoUrl
            .asObservable()
            .subscribe(onNext: { [weak self] (url) in
            if let url = url {
                self?.isLoadingAsset.accept(true)
                let asset = AVAsset(url: url)
                asset.loadValuesAsynchronously(forKeys: [AVPlayerVM.playableKey], completionHandler: {
                    var error: NSError? = nil
                    let status = asset.statusOfValue(forKey: AVPlayerVM.playableKey, error: &error)
                    switch status {
                    case .loaded:
                        let playerItem = AVPlayerItem(asset: asset)
                        DispatchQueue.main.async {
                            self?.isLoadingAsset.accept(false)
                            self?.videoItem.accept(playerItem)
                        }
                    case .failed:
                        ErrorHandler.handle(error: error!)
                    case .cancelled:
                        ErrorHandler.handleError(message: "Load cancelled")
                    default:
                        break
                    }
                })
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
