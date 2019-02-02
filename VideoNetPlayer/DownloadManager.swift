//
//  DownloadManager.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 02/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import Foundation
import RxSwift

class DownloadManager: NSObject {
    static let shared = DownloadManager()
    
    private var session: URLSession!
    fileprivate var dataRecieved = Data()
    fileprivate var expectedData: Float = 0
    
    let isBusy = Variable(false)
    let downloadProgress: Variable<Float> = Variable(0)
    
    override private init() {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    func downloadData(from url: URL) -> Observable<Data> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            guard let this = self else {
                fatalError("Download manager does not exist")
            }
            this.isBusy.value = true
            let task = this.session.dataTask(with: url) { (data, response, error) in
                print(response)
                this.isBusy.value = false
                if let error = error {
                    observer.onError(DownloadError(code: -1, message: error.localizedDescription))
                } else if let data = data {
                    observer.onNext(data)
                }
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        })
    }
}

extension DownloadManager: URLSessionDelegate, URLSessionTaskDelegate {
    
}

extension DownloadManager: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        expectedData = Float(response.expectedContentLength)
        dataRecieved = Data()
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dataRecieved.append(data)
        let progress = Float(dataRecieved.count) / expectedData
        print(progress)
        downloadProgress.value = progress
    }
}

struct DownloadError: Error {
    let code: Int?
    let message: String
}
