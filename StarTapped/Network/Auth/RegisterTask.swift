//
//  RegisterTask.swift
//  StarTapped
//
//  Created by Nova Maday on 1/7/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class RegisterTask: NetworkTask {
    var callback: TaskCallback

    let user: String
    let email: String
    let password: String
    let birthday: String
    let gcap: String

    init(callback: TaskCallback, user: String, email: String, birthday: String, password: String, gcap: String) {
        self.callback = callback
        self.user = user
        self.email = email
        self.birthday = birthday
        self.password = password
        self.gcap = gcap
    }

    func execute() {
        let headers = [
            "Content-Type": "application/json"
        ]

        let params = [
            "username": user,
            "email": email,
            "birthday": birthday,
            "password": password,
            "gcap": gcap
        ]

        Alamofire.request("https://api.startapped.com/v1/account/register", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.result.value != nil {
                            print("success response : \(String(describing: response.result.value))")

                            //Get body
                            var json: JSON = JSON(response.result.value!)

                            let status = NetworkCallStatus(failure: false, success: true, type: TaskType.AUTH_REGISTER).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.result.error))")

                        let status = NetworkCallStatus(failure: true, success: false, type: TaskType.AUTH_REGISTER)

                        self.onComplete(status: status)

                        break
                    }
                }
    }

    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
