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

    func saveAccount(account: Account) {
        KeychainSwift().set(account.isSafeSearch(), forKey: "safe_search", withAccess: .accessibleAfterFirstUnlock)
        KeychainSwift().set(account.getPhoneNumber(), forKey: "phone_number", withAccess: .accessibleAfterFirstUnlock)
        KeychainSwift().set(account.getBirthday(), forKey: "birthday", withAccess: .accessibleAfterFirstUnlock)
    }

    func getAccount() -> Account {
        let account = Account()

        let id: String = KeychainSwift().get("id") ?? "Unassigned"
        let safeSearch: Bool = KeychainSwift().getBool("safe_search") ?? false
        let phone: String = KeychainSwift().get("phone_number") ?? "000.000.0000"
        let birthday: String = KeychainSwift().get("birthday") ?? "1970-01-01"

        account.setAccountId(id: id)
        account.setSafeSearch(safe: safeSearch)
        account.setPhoneNumber(number: phone)
        account.setBirthday(birthday: birthday)

        return account
    }

    func deleteAccount() {
        KeychainSwift().delete("safe_search")
        KeychainSwift().delete("phone_number")
        KeychainSwift().delete("birthday")
    }
}
