//
//  DownloadManager.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 02/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

import Foundation
import RxSwift

final class DownloadManager: NSObject {
    static let shared = DownloadManager()
    
    private var session: URLSession!
    private var task: URLSessionDataTask?
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
                return Disposables.create()
            }
            this.isBusy.value = true
            let task = this.session.dataTask(with: url) { (data, response, error) in
                this.isBusy.value = false
                if let error = error, error.localizedDescription != "cancelled" {
                    observer.onError(DownloadError(code: -1, message: error.localizedDescription))
                } else if let data = data {
                    observer.onNext(data)
                    observer.onCompleted()
                }
            }
            this.task = task
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
    func cancelTask() {
        if let task = task {
            print("Task cancel by User")
            task.cancel()
            self.task = nil
        }
    }
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
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("OK")
    }
}

struct DownloadError: Error {
    let code: Int?
    let message: String
}
