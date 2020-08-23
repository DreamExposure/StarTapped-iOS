//
//  GetAccountForBlogView.swift
//  StarTapped
//
//  Created by Nova Maday on 1/7/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetAccountForBlogViewTask: NetworkTask {
    var callback: TaskCallback

    let id: String

    init(callback: TaskCallback, id: String) {
        self.callback = callback
        self.id = id
    }

    func execute() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization_Access": Settings().getAuthentication().getAccessToken(),
            "Authorization_Refresh": Settings().getAuthentication().getRefreshToken()
        ]

        let params: [String: String] = [
            "id": id
        ]

        AF.request("https://api.startapped.com/v1/account/get/other", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.value != nil {
                            //Get body
                            let json: JSON = JSON(response.value!)
                            let success = NetworkUtils().determineSuccess(code: code)

                            let status = NetworkCallStatus(failure: false, success: success, type: TaskType.ACCOUNT_GET_BLOG).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.error))")

                        let status = NetworkCallStatus(failure: true, success: false, type: TaskType.ACCOUNT_GET_BLOG)

                        self.onComplete(status: status)

                        break
                    }
                }
    }

    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
