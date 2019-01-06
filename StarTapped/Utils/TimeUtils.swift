//
//  TimeUtils.swift
//  StarTapped
//
//  Created by Nova Maday on 1/5/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation

class TimeUtils {
    func getCurrentMillis() -> Int64 {
        return Int64(NSDate().timeIntervalSince1970 * 1000)
    }
}
