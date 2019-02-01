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
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak private var videoPlayerView: UIView!
    @IBOutlet weak private var downloadButton: UIButton!
    @IBOutlet weak private var progressBar: UIProgressView!
    
    let disposeBag = DisposeBag()
    
    let viewModel = VideoPlayerVM()

    override func viewDidLoad() {
        super.viewDidLoad()
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
        downloadButton.setTitle(viewModel.downloadButtonText, for: .normal)
        linkTitleLabel.text = viewModel.linkLabelText
        _ = urlTextField.rx.text
            .orEmpty
            .map { $0.isValidURL() }
            .bind(to: downloadButton.rx.isEnabled)
            .disposed(by: disposeBag)
        _ = downloadButton.rx.tap.subscribe(onNext: { _ in
            print("tap")
        })
    }
}

extension VideoPlayerVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
