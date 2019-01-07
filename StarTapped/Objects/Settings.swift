//
//  Settings.swift
//  StarTapped
//
//  Created by Nova Maday on 1/7/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import KeychainSwift

class Settings {

    func saveAuthentication(auth: AccountAuthentication) {
        KeychainSwift().set(auth.getAccountId(), forKey: "id", withAccess: .accessibleAfterFirstUnlock)
        KeychainSwift().set(auth.getRefreshToken(), forKey: "refresh", withAccess: .accessibleAfterFirstUnlock)
        KeychainSwift().set(auth.getAccessToken(), forKey: "access", withAccess: .accessibleAfterFirstUnlock)
        KeychainSwift().set("\(auth.getExpire())", forKey: "expire", withAccess: .accessibleAfterFirstUnlock)

    }

    func getAuthentication() -> AccountAuthentication {
        let auth = AccountAuthentication()

        let id: String = KeychainSwift().get("id") ?? "Unassigned"
        let refresh: String = KeychainSwift().get("refresh") ?? "Unassigned"
        let access: String = KeychainSwift().get("access") ?? "Unassigned"
        let expire: Int64 = Int64(KeychainSwift().get("expire") ?? "0") ?? 0

        auth.setAccountId(accountId: id)
        auth.setRefreshToken(token: refresh)
        auth.setAccessToken(token: access)
        auth.setExpire(expire: expire)

        return auth
    }

    func deleteAuthentication() {
        KeychainSwift().delete("id")
        KeychainSwift().delete("refresh")
        KeychainSwift().delete("access")
        KeychainSwift().delete("expire")
    }
}
