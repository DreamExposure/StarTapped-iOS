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
    
    init(month: Int, year: Int) {
        self.month = month
        self.year = year
    }
    
    //Getters
    func getMonth() -> Int {
        return self.month
    }
    
    func getYear() -> Int {
        return self.year
    }
    
    //TODO: Get start
    
    //TODO: Get Stop
    
    //Setters
    func setMonth(month: Int) {
        if (month < 0) {
            self.month = 0
        } else if (month > 11) {
            self.month = 11
        } else {
            self.month = month
        }
    }
    
    func setYear(year: Int) {
        self.year = year
    }
    
    //Functions
    
    func forwardOneMonth() {
        if (self.month == 11) {
            self.month = 0
            self.year += 1
        } else {
            self.month += 1
        }
    }
    
    func backwardOneMonth() {
        if (self.month == 0) {
            self.month = 11
            self.year -= 1
        } else {
            self.month -= 1
        }
    }
}
