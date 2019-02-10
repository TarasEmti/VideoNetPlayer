//
//  VideoPlayerVMTests.swift
//  VideoNetPlayerTests
//
//  Created by Тарас Минин on 10/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking

@testable import VideoNetPlayer

class VideoPlayerVMTests: XCTestCase {

    var sut: VideoPlayerVM!
    var downloadService: MockDownloadService!
    
    override func setUp() {
        downloadService = MockDownloadService()
        sut = VideoPlayerVM(videoLink: nil, downloadService: downloadService!)
    }
    
    func test_setup() {
        let isUploading = try? sut.isServiceUploading.asObservable().toBlocking().first()
        XCTAssertTrue(isUploading == false)
        XCTAssertNil(sut.uploadProgress.value)
    }
    
    func test_acceptWebUrl() {
        sut.uploadVideo(from: URL(string: "https://www.google.com")!)
        XCTAssertTrue(sut.videoUrl.value != nil)
        XCTAssertTrue(sut.isServiceUploading.value == true)
    }

    override func tearDown() {
        downloadService = nil
        sut = nil
    }

    func test_buttonTexts() {
        XCTAssert(!sut.cancelDownloadButtonText.isEmpty)
        XCTAssert(!sut.downloadButtonText.isEmpty)
        XCTAssert(!sut.linkLabelText.isEmpty)
        XCTAssert(!sut.urlTextFieldPlaceholder.isEmpty)
    }
}
