//
// Created by Nova Maday on 2019-01-06.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation

protocol AsyncTask {
    var callback: TaskCallback { get }

    func execute()

    func onComplete(status: NetworkCallStatus)
}
