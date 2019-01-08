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
    
    func dateIsInFuture(date1: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        // Extract the components of the dates
        let dateComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1)
        let nowComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        
        let dateYear = dateComp.year ?? 0
        let dateMonth = dateComp.month ?? 0
        let dateDay = dateComp.day ?? 0
        
        let nowYear = nowComp.year ?? 0
        let nowMonth = nowComp.month ?? 0
        let nowDay = nowComp.day ?? 0
        
        if dateYear > nowYear {
            return true
        } else if dateYear == nowYear && dateMonth > nowMonth {
            return true
        } else if dateYear == nowYear && dateMonth == nowMonth && dateDay > nowDay {
            return true
        }
        return false
    }
    
    func calculatAge(ageString: String) -> Int {
        let DATE_FORMAT = "yyyy-MM-dd"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        
        let dateFromString: Date? = dateFormatter.date(from: ageString)
        
        if let date = dateFromString {
            let calendar = Calendar.current
            let now = Date()
            
            // Extract the components of the dates
            let dateComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            let nowComp = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
            
            return (nowComp.year ?? 0) - (dateComp.year ?? 0)
        }
        
        return -1
    }
}
