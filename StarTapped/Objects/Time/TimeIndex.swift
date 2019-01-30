//
//  TimeIndex.swift
//  StarTapped
//
//  Created by Nova Maday on 1/18/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation

class TimeIndex {
    private var month: Int
    private var year: Int
    
    init() {
        let now = Date()
        let calendar = Calendar.current

        let nowComp = calendar.dateComponents([.year, .month], from: now)

        self.month = nowComp.month ?? 1
        self.year = nowComp.year ?? 2019
    }
    
    //Getters
    func getMonth() -> Int {
        return self.month
    }
    
    func getYear() -> Int {
        return self.year
    }
    
    func getStart() -> Int64 {
        var dateComponents = DateComponents()

        dateComponents.year = self.year
        dateComponents.month = self.month
        dateComponents.day = 1
        dateComponents.timeZone = Calendar.current.timeZone
        dateComponents.hour = 0
        dateComponents.minute = 0

        let start = Calendar.current.date(from: dateComponents)

        return Int64((start?.timeIntervalSince1970)! * 1000)
    }

    func getStop() -> Int64 {
        var dateComponents = DateComponents()

        dateComponents.year = self.year
        dateComponents.month = self.month + 1
        dateComponents.day = 1
        dateComponents.timeZone = Calendar.current.timeZone
        dateComponents.hour = 0
        dateComponents.minute = 0

        let stop = Calendar.current.date(from: dateComponents)

        return Int64((stop?.timeIntervalSince1970)! * 1000)
    }
    
    //Setters
    func setMonth(month: Int) {
        if (month < 1) {
            self.month = 1
        } else if (month > 12) {
            self.month = 12
        } else {
            self.month = month
        }
    }
    
    func setYear(year: Int) {
        self.year = year
    }
    
    //Functions
    
    func forwardOneMonth() {
        if (self.month == 12) {
            self.month = 1
            self.year += 1
        } else {
            self.month += 1
        }
    }
    
    func backwardOneMonth() {
        if (self.month == 1) {
            self.month = 12
            self.year -= 1
        } else {
            self.month -= 1
        }
    }
}
