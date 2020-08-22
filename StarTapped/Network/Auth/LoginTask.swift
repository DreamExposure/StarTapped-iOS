//
// Created by Nova Maday on 2019-01-06.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class LoginTask: NetworkTask {

    var callback: TaskCallback

    let email: String
    let password: String
    let gcap: String

    init(callback: TaskCallback, email: String, password: String, gcap: String) {
        self.callback = callback
        self.email = email
        self.password = password
        self.gcap = gcap
    }

    func execute() {
        let headers = [
            "Content-Type": "application/json"
        ]
        
        let params = [
            "email": email,
            "password": password,
            "gcap": gcap
        ]

        Alamofire.request("https://api.startapped.com/v1/account/login", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.result.value != nil {
                            //Get body
                            let json: JSON = JSON(response.result.value!)
                            let success = NetworkUtils().determineSuccess(code: code)

                            let status = NetworkCallStatus(failure: false, success: success, type: TaskType.AUTH_LOGIN).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.result.error))")

                        let status = NetworkCallStatus(failure: true, success: false, type: TaskType.AUTH_LOGIN)

                        self.onComplete(status: status)
                        
                        break
                    }
                }
    }

    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
