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
    
    lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.style = .whiteLarge
        view.addSubview(activityView)
        activityView.hidesWhenStopped = true
        return activityView
    }()
    
    let viewModel = AVPlayerVM()
    
    private let playerLayer = AVPlayerLayer()
    private var observerToken: Any?
    private let isHudShown = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPlayerTimeLabel.layer.cornerRadius = 5
        videoLengthLabel.layer.cornerRadius = 5
        playPauseButton.tintColor = .red
        videoSlider.isUserInteractionEnabled = false
        videoSlider.maximumTrackTintColor = .white
        setupPlayerLayer()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if playerLayer.player?.currentItem != nil {
            isHudShown.accept(true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        playerLayer.player?.pause()
    }
    
    deinit {
        releasePeriodicTimeObserver()
    }
    
    private func setupPlayerLayer() {
        view.layer.addSublayer(playerLayer)
        playerLayer.zPosition = -1
        playerLayer.videoGravity = .resizeAspectFill
        view.clipsToBounds = true
        let player = AVPlayer()
        player.rx.observe(Float.self, "rate").subscribe(onNext: { [weak self] (rate) in
            if let rate = rate {
                if rate == 0 {
                    let playImage = UIImage(named: "player_play")
                    self?.playPauseButton.setImage(playImage, for: .normal)
                } else {
                    let pauseImage = UIImage(named: "player_pause")
                    self?.playPauseButton.setImage(pauseImage, for: .normal)
                }
            }
        }).disposed(by: disposeBag)
        player.preventsDisplaySleepDuringVideoPlayback = true
        playerLayer.player = player
    }
    
    override func viewDidLayoutSubviews() {
        playerLayer.frame = view.frame
        activityView.center = view.center
    }
    
    private func bind() {
        let gr = UITapGestureRecognizer(target: view, action: nil)
        gr.rx.event.asObservable().subscribe(onNext: { [weak self] (_) in
            guard let this = self,
                this.playerLayer.player?.currentItem != nil else {
                return 
            }
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
                    if player.currentTime() == player.currentItem?.duration {
                        player.seek(to: .zero)
                    }
                    player.play()
                } else {
                    player.pause()
                }
            }
        }).disposed(by: disposeBag)
        
        viewModel.videoItem.asObservable().subscribe(onNext: { [weak self] (item) in
            guard let this = self,
                let player = this.playerLayer.player else {
                    return
            }
            if let item = item {
                this.videoSlider.maximumValue = Float(item.asset.duration.seconds)
                player.replaceCurrentItem(with: item)
                player.seek(to: .zero)
                this.addPeriodicTimeObserver()
                player.play()
            } else {
                this.hudViewLayer.alpha = 0
                this.currentPlayerTimeLabel.text = "--:--"
            }
        }).disposed(by: disposeBag)
        
        viewModel.videoDuration
            .bind(to: videoLengthLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.videoName
            .bind(to: videoTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLoadingAsset
            .bind(to: activityView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    func addPeriodicTimeObserver() {
        if let player = playerLayer.player {
            let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            let queue = DispatchQueue.main
            observerToken = player.addPeriodicTimeObserver(forInterval: interval, queue: queue, using: { [weak self] (time) in
                self?.currentPlayerTimeLabel.text = time.toString()
                self?.videoSlider.value = Float(time.seconds)
            })
        }
    }
    
    func releasePeriodicTimeObserver() {
        if let observer = observerToken {
            playerLayer.player?.removeTimeObserver(observer)
        }
    }
}
