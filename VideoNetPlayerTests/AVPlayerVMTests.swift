//
//  AVPlayerVMTests.swift
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

class AVPlayerVMTests: XCTestCase {
    
    var sut: AVPlayerVM!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        sut = AVPlayerVM()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        sut = nil
        scheduler = nil
        disposeBag = nil
    }

    func test_startSetup() {
        XCTAssertNil(sut.videoUrl.value)
        XCTAssertNil(sut.videoItem.value)
        XCTAssertEqual(sut.videoName.value, "")
        XCTAssertEqual(sut.videoDuration.value, "--:--")
    }
    
    func test_assetLoad() {
        let isLoading = scheduler.createObserver(Bool.self)
        
        sut.isLoadingAsset
            .asDriver()
            .drive(isLoading)
            .disposed(by: disposeBag)
        
        let stubUrl = URL(string: "https://sample-videos.com/video123/mp4/480/big_buck_bunny_480p_30mb.mp4")!
        scheduler.createColdObservable([.next(10, stubUrl)])
            .bind(to: sut.videoUrl)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        
    XCTAssertEqual(isLoading.events, [.next(0, false),
                                      .next(10, true)])
    }
}
