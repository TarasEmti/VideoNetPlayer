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
    private var task: URLSessionDownloadTask?
    
    var observer: AnyObserver<Data>?
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
            let task = this.session.downloadTask(with: url)
            this.task = task
            task.resume()
            this.observer = observer
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
    func cancelTask() {
        if let task = task {
            print("Task cancel by User")
            task.cancel()
            downloadComplete()
        }
    }
    
    fileprivate func downloadComplete() {
        self.task = nil
        isBusy.value = false
        downloadProgress.value = 0
        observer?.onCompleted()
        observer = nil
    }
}

extension DownloadManager: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data.init(contentsOf: location) {
            observer?.onNext(data)
        }
        downloadComplete()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        downloadProgress.value = (Float(totalBytesWritten)/Float(totalBytesExpectedToWrite))
    }
}

extension DownloadManager: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        print("waiting")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            observer?.onError(DownloadError(code: -2, message: error.localizedDescription))
            downloadComplete()
        }
    }
}
