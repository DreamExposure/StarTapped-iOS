//
// Created by Nova Maday on 2019-01-07.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import Guitar
import SwiftMoment

class Validator {

    func validEmail(input: String) -> Bool {
        return Guitar(chord: .email).test(string: input)
    }
    
    func validPhoneNumber(input: String) -> Bool {
        let scaryAsShitPhoneNumberRegex: String = "^(?:(?:\\+?1\\s*(?:[.-]\\s*)?)?(?:\\(\\s*([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9])\\s*\\)|([2-9]1[02-9]|[2-9][02-8]1|[2-9][02-8][02-9]))\\s*(?:[.-]\\s*)?)?([2-9]1[02-9]|[2-9][02-9]1|[2-9][02-9]{2})\\s*(?:[.-]\\s*)?([0-9]{4})(?:\\s*(?:#|x\\.?|ext\\.?|extension)\\s*(\\d+))?$"
        
        return Guitar(pattern: scaryAsShitPhoneNumberRegex).test(string: input)
    }

    func validBirthate(input: String) -> Bool {
        let DATE_FORMAT = "yyyy-MM-dd"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT

        let dateFromString: Date? = dateFormatter.date(from: input)

        if let date = dateFromString {
            var inFuture = TimeUtils().dateIsInFuture(date1: date)
            inFuture.toggle()
            return inFuture
        }
        
        return false
    }
    
    func validBlogUrlLength(input: String) -> Bool {
        return input.count >= 3 && input.count <= 60
    }
    
    func validColorCode(input: String) -> Bool {
        return Guitar(pattern: "#([0-9a-f]{3}|[0-9a-f]{6}|[0-9a-f]{8})").test(string: input)
    }
    
    func getUrlSubStrings(input: String) -> [String] {
        var subs: [String] = []
        let pattern = Guitar(pattern: "(?:(?:https?|ftp|file)://|www.|ftp.)(?:([-A-Z0-9+&@#/%=~_|$?!:,.]*)|[-A-Z0-9+&@#/%=~_|$?!:,.])*(?:([-A-Z0-9+&@#/%=~_|$?!:,.]*)|[A-Z0-9+&@#/%=~_|$])")
        
        for sub in input.components(separatedBy: " ") {
            if pattern.test(string: sub) {
                subs.append(sub)
            }
        }
        
        return subs
    }
}
