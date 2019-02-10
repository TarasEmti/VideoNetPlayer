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
    
    func test_acceptWebUrl() {
        sut.uploadVideo(from: URL(string: "https://www.google.com")!)
        XCTAssertTrue(sut.videoUrl.value != nil)
    }
    
    func test_acceptLocalUrl() {
        sut.uploadVideo(from: DiskStorage.shared.tempVideoFolder)
        XCTAssertTrue(sut.videoUrl.value != nil)
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
