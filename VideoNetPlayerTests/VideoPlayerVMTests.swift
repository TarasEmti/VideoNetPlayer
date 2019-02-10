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
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
