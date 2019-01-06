//
//  NetworkCallStatus.swift
//  StarTapped
//
//  Created by Nova Maday on 1/6/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class NetworkCallStatus {
    let success: Bool
    let type: TaskType
    var code: Int = 0
    var message: String = "Unassigned"

    var body: JSON = []

    init(success: Bool, type: TaskType) {
        self.success = success
        self.type = type
    }

    //Getters
    func isSuccess() -> Bool {
        return success
    }

    func getType() -> TaskType {
        return type
    }

    func getCode() -> Int {
        return code
    }

    func getMessage() -> String {
        return message
    }

    func getBody() -> JSON {
        return body
    }

    //Setters
    func setCode(code: Int) -> NetworkCallStatus {
        self.code = code

        return self
    }

    func setMessage(message: String) -> NetworkCallStatus {
        self.message = message

        return self
    }

    func setBody(body: JSON) -> NetworkCallStatus {
        self.body = body

        return self
    }
}
