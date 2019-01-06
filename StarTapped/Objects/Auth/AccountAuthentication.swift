//
//  AccountAuthentication.swift
//  StarTapped
//
//  Created by Nova Maday on 1/5/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class AccountAuthentication {
    var accountId: String = "Unassigned"

    var refreshToken: String = "Unassigned"
    var accessToken: String = "Unassigned"

    var expire: Int64 = TimeUtils().getCurrentMillis()

    //Getters
    func getAccountId() -> String {
        return accountId
    }

    func getRefreshToken() -> String {
        return refreshToken
    }

    func getAccessToken() -> String {
        return accessToken
    }

    func getExpire() -> Int64 {
        return expire
    }

    //Setters
    func setAccountId(accountId: String) {
        self.accountId = accessToken
    }

    func setRefreshToken(token: String) {
        self.refreshToken = token
    }

    func setAccessToken(token: String) {
        self.accessToken = token
    }

    func setExpire(expire: Int64) {
        self.expire = expire
    }

    //JSON Handling
    func toJson() -> JSON {
        return [
            "account_id": self.accountId,
            "refresh_token": self.refreshToken,
            "access_token": self.accessToken,
            "expire": self.expire
        ]
    }

    func fromJson(json: JSON) -> AccountAuthentication {
        self.accountId = json["account_id"].stringValue
        self.refreshToken = json["refresh_token"].stringValue
        self.accessToken = json["access_token"].stringValue
        self.expire = json["expire"].int64Value

        return self
    }
}
