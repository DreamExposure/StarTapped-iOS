//
//  DownloadImageTask.swift
//  StarTapped
//
//  Created by Nova Maday on 1/13/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SDWebImage

class DownloadImageTask: NetworkTask {
    var callback: TaskCallback
    let imageUrl: String
    let imageView: UIImageView
    
    init(callback: TaskCallback, url: String, view: UIImageView) {
        self.callback = callback
        self.imageUrl = url
        self.imageView = view
    }
    
    func execute() {
        imageView.sd_setImage(with: URL(string: imageUrl))
    }
    
    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
