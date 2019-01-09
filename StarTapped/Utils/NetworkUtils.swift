//
//  NetworkUtils.swift
//  StarTapped
//
//  Created by Nova Maday on 1/8/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation

class NetworkUtils {
    func determineSuccess(code: Int) -> Bool {
        if (code >= 200 && code <= 299) {
            return true
        }
        return false
    }
}
