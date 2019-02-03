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
    @IBOutlet weak private var progressBar: UIProgressView!
    
    private let videoPlayer = AVPlayerController()
    
    private let disposeBag = DisposeBag()
    let viewModel = VideoPlayerVM(videoLink: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4")

    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(videoPlayer)
        videoPlayerView.addSubview(videoPlayer.view)
        videoPlayer.view.frame = videoPlayerView.bounds
        progressBarSetup()
        urlTextFieldSetup()
        bind()
    }
    
    private func progressBarSetup() {
        progressBar.setProgress(0, animated: false)
        progressBar.progressTintColor = .red
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
        linkTitleLabel.text = viewModel.linkLabelText
        
        _ = urlTextField.rx.text
            .orEmpty
            .map { $0.isValidURL() }
            .bind(to: downloadButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        _ = downloadButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let this = self,
             let url = URL(string: this.urlTextField.text ?? "") else {
                return
            }
            DownloadManager.shared.downloadData(from: url)
                .observeOn(MainScheduler.asyncInstance)
                .subscribe(onNext: { (data) in
                    do {
                        let df = DateFormatter()
                        df.dateFormat = "yyyy-MM-dd_HH-mm-ss"
                        let videoName = String(format: "tempVideo-%@.%@", df.string(from: Date()),url.pathExtension)
                        let temp = FileManager.default.temporaryDirectory.appendingPathComponent(videoName)
                        try data.write(to: temp)
                        print("New video at: \(temp)")
                        this.videoPlayer.loadVideo(url: temp)
                    } catch {
                        print(error)
                    }
                }, onError: { error in
                    let downloadError = error as? DownloadError
                    let alert = UIAlertController(title: "Ошибка", message: downloadError?.message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    this.present(alert, animated: true, completion: nil)
                }).disposed(by: this.disposeBag)
        }).disposed(by: disposeBag)
        
        _ = DownloadManager.shared.isBusy.asObservable()
            .map { !$0 }
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: progressBar.rx.isHidden)
            .disposed(by: disposeBag)

        _ = DownloadManager.shared.downloadProgress.asObservable()
            .observeOn(MainScheduler.asyncInstance)
            .bind(to: progressBar.rx.progress)
            .disposed(by: disposeBag)
        
        let file = FileManager.default.temporaryDirectory.appendingPathComponent("tempVideo-2019-02-02_23-39-35.mp4")
        videoPlayer.loadVideo(url: file)
    }
}

extension VideoPlayerVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
