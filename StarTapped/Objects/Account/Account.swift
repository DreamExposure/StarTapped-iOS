//
// Created by Nova Maday on 2019-01-05.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class Account {
    var accountId: String = "Unassigned"

    var username: String = "Unassigned"
    var email: String = "Unassigned"
    var phoneNumber: String = "000.000.0000"
    var birthday: String = "1970-1-1"

    var safeSearch: Bool = false

    var verified: Bool = false
    var emailConfirmed: Bool = false

    var admin: Bool = false

    //Getters
    func getAccountId() -> String {
        return accountId
    }

    func getUsername() -> String {
        return username
    }

    func getEmail() -> String {
        return email
    }

    func getPhoneNumber() -> String {
        return phoneNumber
    }

    func getBirthday() -> String {
        return birthday
    }

    func isSafeSearch() -> Bool {
        return safeSearch
    }

    func isVerified() -> Bool {
        return verified
    }

    func isEmailConfirmed() -> Bool {
        return emailConfirmed
    }

    func isAdmin() -> Bool {
        return admin
    }

    //Setters
    func setAccountId(id: String) {
        self.accountId = id
    }

    func setUsername(username: String) {
        self.username = username;
    }

    func setEmail(email: String) {
        self.email = email
    }

    func setPhoneNumber(number: String) {
        self.phoneNumber = number
    }

    func setSafeSearch(safe: Bool) {
        self.safeSearch = safe
    }

    func setVerified(verified: Bool) {
        self.verified = verified
    }

    func setEmailConfirmed(confirmed: Bool) {
        self.emailConfirmed = confirmed
    }

    func setAdmin(admin: Bool) {
        self.admin = admin
    }

    //JSON handling
    func toJson() -> JSON {
        return [
            "account_id": self.accountId,
            "username": self.username,
            "email": self.email,
            "phone_number": self.phoneNumber,
            "birthday": self.birthday,
            "safe_search": self.safeSearch,
            "verified": self.verified,
            "email_confirmed": self.emailConfirmed,
            "admin": self.admin
        ]
    }

    func fromJson(json: JSON) -> Account {

        self.accountId = json["account_id"].stringValue
        self.username = json["username"].stringValue
        if let email = json["email"].string {
            self.email = email
        }
        if let phoneNumber = json["phone_number"].string {
            self.phoneNumber = phoneNumber
        }
        self.birthday = json["birthday"].stringValue
        self.safeSearch = json["safe_search"].boolValue
        self.verified = json["verified"].boolValue
        if let emailConfirmed = json["email_confirmed"].bool {
            self.emailConfirmed = emailConfirmed
        }
        self.admin = json["admin"].boolValue

        return self
    }
}
