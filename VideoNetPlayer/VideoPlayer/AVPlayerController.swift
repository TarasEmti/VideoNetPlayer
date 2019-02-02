//
//  AVPlayerController.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 02/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVKit
import AVFoundation

class AVPlayerController: UIViewController {
    @IBOutlet weak var hudViewLayer: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoSlider: UISlider!
    
    private let playerLayer = AVPlayerLayer()
    private let isHudShown = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayerLayer()
        bind()
    }
    
    private func setupPlayerLayer() {
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.frame
        playerLayer.videoGravity = .resizeAspectFill
        view.clipsToBounds = true
    }
    
    private func bind() {
        let gr = UITapGestureRecognizer(target: view, action: nil)
        gr.rx.event.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let this = self else { return }
            let oldValue = this.isHudShown.value
            this.isHudShown.accept(!oldValue)
        }).disposed(by: disposeBag)
        view.addGestureRecognizer(gr)
        
        isHudShown.asObservable().subscribe(onNext: { (isShown) in
            UIView.animate(withDuration: 0.2, animations: { [weak self] in
                guard let this = self else { return }
                if isShown {
                    this.hudViewLayer.alpha = 1
                } else {
                    this.hudViewLayer.alpha = 0
                }
                }, completion: nil)
        }).disposed(by: disposeBag)
        
        playPauseButton.rx.tap.subscribe(onNext: { [weak self] _ in
            if let player = self?.playerLayer.player {
                if player.rate == 1 {
                    player.pause()
                } else {
                    player.play()
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func loadVideo(url: URL) {
        let player = AVPlayer(url: url)
        playerLayer.player = player
        player.seek(to: .zero)
        player.play()
        videoTitleLabel.text = url.lastPathComponent
    }
}
