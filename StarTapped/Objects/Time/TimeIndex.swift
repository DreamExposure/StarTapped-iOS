//
//  TimeIndex.swift
//  StarTapped
//
//  Created by Nova Maday on 1/18/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation

class TimeIndex {
    private var before: Int64
    private var latest: Int64
    private var oldest: Int64
    
    init() {
        before = TimeUtils().getCurrentMillis()
        latest = before
        oldest = before
        
    }
    
    //Getters
    func getBefore() -> Int64 {
        return self.before
    }
    
    func getLatest() -> Int64 {
        return self.latest
    }
    
    func getOldest() -> Int64 {
        return self.oldest
    }
    
    //Setters
    func setBefore(before: Int64) {
        self.before = before
    }
    
    func setLatest(latest: Int64) {
        self.latest = latest
    }
    
    func setOldest(oldest: Int64) {
        self.oldest = oldest
    }
}
