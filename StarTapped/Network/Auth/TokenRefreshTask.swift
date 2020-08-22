//
//  TokenRefreshTask.swift
//  StarTapped
//
//  Created by Nova Maday on 1/7/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class TokenRefreshTask: NetworkTask {
    var callback: TaskCallback

    init(callback: TaskCallback) {
        self.callback = callback
    }

    func execute() {
        let auth = Settings().getAuthentication()
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization_Access": auth.getAccessToken(),
            "Authorization_Refresh": auth.getRefreshToken()
        ]

        let params: [String: String] = [:]

        Alamofire.request("https://api.startapped.com/v1/auth/refresh", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.result.value != nil {
                            //Get body
                            let json: JSON = JSON(response.result.value!)
                            let success = NetworkUtils().determineSuccess(code: code)

                            let status = NetworkCallStatus(failure: false, success: success, type: TaskType.AUTH_TOKEN_REAUTH).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.result.error))")

                        let status = NetworkCallStatus(failure: true, success: false, type: TaskType.AUTH_TOKEN_REAUTH)

                        self.onComplete(status: status)

                        break
                    }
                }
    }

    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
