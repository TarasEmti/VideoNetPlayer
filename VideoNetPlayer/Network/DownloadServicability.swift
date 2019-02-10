//
//  DownloadServicability.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 10/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import RxSwift

protocol DownloadServicability {
    func downloadData(from url: URL) -> Observable<Data>
    func cancelTask()
    var isBusy: Variable<Bool> { get }
    var downloadProgress: Variable<Float?> { get }
}
