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
    @IBOutlet weak private var hudViewLayer: UIView!
    @IBOutlet weak private var playPauseButton: UIButton!
    @IBOutlet weak private var videoTitleLabel: UILabel!
    @IBOutlet weak private var videoSlider: UISlider!
    @IBOutlet weak private var currentPlayerTimeLabel: UILabel!
    @IBOutlet weak private var videoLengthLabel: UILabel!
    
    private let playerLayer = AVPlayerLayer()
    private let isHudShown = BehaviorRelay(value: false)
    private let isPlayerPlaying = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hudViewLayer.alpha = 0
        currentPlayerTimeLabel.text = "--:--"
        currentPlayerTimeLabel.layer.cornerRadius = 5
        videoLengthLabel.text = "--:--"
        videoLengthLabel.layer.cornerRadius = 5
        playPauseButton.tintColor = .red
        setupPlayerLayer()
        bind()
    }
    
    private func setupPlayerLayer() {
        view.layer.addSublayer(playerLayer)
        playerLayer.zPosition = -1
        playerLayer.frame = view.frame
        playerLayer.videoGravity = .resizeAspect
        view.clipsToBounds = true
        let player = AVPlayer()
        player.preventsDisplaySleepDuringVideoPlayback = true
        playerLayer.player = player
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
                if player.rate == 0 {
                    player.play()
                    self?.isPlayerPlaying.accept(true)
                } else {
                    player.pause()
                    self?.isPlayerPlaying.accept(false)
                }
            }
        }).disposed(by: disposeBag)
        
        isPlayerPlaying.subscribe(onNext: { [weak self] (isPlaying) in
            if isPlaying {
                let pauseImage = UIImage(named: "player_pause")
                self?.playPauseButton.setImage(pauseImage, for: .normal)
            } else {
                let playImage = UIImage(named: "player_play")
                self?.playPauseButton.setImage(playImage, for: .normal)
            }
        }).disposed(by: disposeBag)
        

    }
    
    @IBAction func sliderMoved(_ sender: Any) {
        if let player = playerLayer.player, player.currentItem != nil {
            let time = CMTime(seconds: Double(videoSlider.value),
                              preferredTimescale: 900)
            player.seek(to: time)
        }
    }
    
    func loadVideo(url: URL) {
        let item = AVPlayerItem(url: url)
        if let player = playerLayer.player {
            player.replaceCurrentItem(with: item)
            player.seek(to: .zero)
            player.play()
            isPlayerPlaying.accept(true)
            videoTitleLabel.text = String(format: "\t%@", url.lastPathComponent)
            videoLengthLabel.text = item.asset.duration.toString()
            videoSlider.maximumValue = Float(item.asset.duration.seconds)
        }
    }
}
