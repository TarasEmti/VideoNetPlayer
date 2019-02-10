//
//  VideoPlayerVMTests.swift
//  VideoNetPlayerTests
//
//  Created by Тарас Минин on 10/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import XCTest

@testable import VideoNetPlayer

class VideoPlayerVMTests: XCTestCase {

    var sut: VideoPlayerVM!
    var downloadService: MockApiService!
    
    override func setUp() {
        downloadService = MockApiService()
        sut = VideoPlayerVM(videoLink: nil, downloadService: downloadService!)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        downloadService = nil
        sut = nil
    }

    func test_start() {
        let mockUrl = URL.init(fileURLWithPath: "")
        sut.uploadVideo(from: mockUrl)
        XCTAssert(sut.downloadService.isBusy.toBlocking())
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
