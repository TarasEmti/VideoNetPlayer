//
//  VideoPlayerVC.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 31/01/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class VideoPlayerVC: UIViewController {
    
    @IBOutlet weak private var linkTitleLabel: UILabel!
    @IBOutlet weak private var urlTextField: UITextField!
    @IBOutlet weak private var videoPlayerView: UIView!
    @IBOutlet weak private var downloadButton: UIButton!
    @IBOutlet weak private var cancelButton: UIButton!
    @IBOutlet weak private var progressBar: UIProgressView!
    
    private let videoPlayer = AVPlayerController()
    
    private let disposeBag = DisposeBag()
    let viewModel = VideoPlayerVM()

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(videoPlayer)
        videoPlayerView.addSubview(videoPlayer.view)
        navigationController?.hidesBarsWhenVerticallyCompact = true

        navBarSetup()
        urlTextFieldSetup()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        videoPlayer.view.frame = videoPlayerView.bounds
    }
    
    private func navBarSetup() {
        title = "Aloha Test".localized
        let videoFolderItem = UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil)
        navigationItem.rightBarButtonItem = videoFolderItem
        videoFolderItem.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self else { return }
            let vc = VideoStorageVC()
            vc.viewModel.chosenItem.asObservable().filter({$0 != nil}).subscribe(onNext: { (url) in
                this.videoPlayer.loadVideo(url: url!)
            }).disposed(by: this.disposeBag)
            this.show(vc, sender: self)
        }).disposed(by: disposeBag)
    }
    
    private func urlTextFieldSetup() {
        urlTextField.delegate = self
        urlTextField.placeholder = viewModel.urlTextFieldPlaceholder
        urlTextField.keyboardType = .URL
        urlTextField.returnKeyType = .go
    }
    
    private func bind() {
        urlTextField.text = viewModel.videoLink
        downloadButton.setTitle(viewModel.downloadButtonText, for: .normal)
        cancelButton.setTitle(viewModel.cancelDownloadButtonText, for: .normal)
        linkTitleLabel.text = viewModel.linkLabelText
        
        viewModel.videoUrl.subscribe(onNext: { [weak self] (url) in
            guard let this = self,
                let url = url else { return }
            this.videoPlayer.loadVideo(url: url)
        }).disposed(by: disposeBag)
        
        urlTextField.rx.text
            .orEmpty
            .map { $0.isValidVideoURL() }
            .bind(to: downloadButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        downloadButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self,
             let url = URL(string: this.urlTextField.text ?? "") else {
                return
            }
            this.urlTextField.resignFirstResponder()
            this.viewModel.uploadVideo(from: url)
        }).disposed(by: disposeBag)
        
        DownloadManager.shared.isBusy.asObservable()
            .map { !$0 }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: progressBar.rx.isHidden)
            .disposed(by: disposeBag)

        DownloadManager.shared.downloadProgress.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: progressBar.rx.progress)
            .disposed(by: disposeBag)
        
        DownloadManager.shared.isBusy.asObservable()
            .map { !$0 }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: cancelButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        DownloadManager.shared.isBusy.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: downloadButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        cancelButton.rx.tap
            .subscribe(onNext: { _ in
                DownloadManager.shared.cancelTask()
            })
            .disposed(by: disposeBag)
        
        #if DEBUG
            urlTextField.text = "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4"
        #endif
    }
    
    @IBAction func videoFormatInfo(_ sender: Any) {
        let videoSupportMessage = "videoSupportMessage".localized
        let supportFormat = String(format: "%@%@", videoSupportMessage, DiskManager.shared.supportedVideo.joined(separator: ", "))
        UIAlertController.show(title: "Warning".localized, message: supportFormat)
    }
}

extension VideoPlayerVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
