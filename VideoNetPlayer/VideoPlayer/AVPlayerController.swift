//
//  AVPlayerController.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 02/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import UIKit
import RxSwift
import AVKit
import AVFoundation

class AVPlayerController: UIViewController {
    @IBOutlet weak var hudViewLayer: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var videoSlider: UISlider!
    
    private let playerLayer = AVPlayerLayer()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(playerLayer)
        playerLayer.frame = view.frame
        playerLayer.videoGravity = .resizeAspectFill
        view.clipsToBounds = true
        bind()
    }
    
    private func bind() {
        let gr = UITapGestureRecognizer(target: view, action: nil)
        gr.rx.event.asObservable().subscribe { [weak self] (_) in
            guard let this = self else { return }
            print("hud show / hide")
            this.hudViewLayer.isHidden = !this.hudViewLayer.isHidden
        }.disposed(by: disposeBag)
        hudViewLayer.addGestureRecognizer(gr)
    }
    
    func loadVideo(url: URL) {
        let player = AVPlayer(url: url)
        playerLayer.player = player
        player.seek(to: .zero)
        player.play()
    }
}
