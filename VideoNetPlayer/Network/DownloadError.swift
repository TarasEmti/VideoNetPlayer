//
//  DownloadError.swift
//  VideoNetPlayer
//
//  Created by Тарас Минин on 03/02/2019.
//  Copyright © 2019 Тарас Минин. All rights reserved.
//

struct DownloadError: Error {
    let code: Int?
    let message: String
}
