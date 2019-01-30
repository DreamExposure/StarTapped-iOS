//
// Created by Nova Maday on 2019-01-28.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class GetPostsForHubTask: NetworkTask {
    var callback: TaskCallback
    var index: TimeIndex


    init(callback: TaskCallback, index: TimeIndex) {
        self.callback = callback
        self.index = index
    }

    func execute() {
        let headers = [
            "Content-Type": "application/json",
            "Authorization_Access": Settings().getAuthentication().getAccessToken(),
            "Authorization_Refresh": Settings().getAuthentication().getRefreshToken()
        ]

        let params: [String: Any] = [
            "year": index.getYear(),
            "month": index.getMonth()-1
        ]

        Alamofire.request("https://api.startapped.com/v1/post/get/hub", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.result.value != nil {
                            //Get body
                            var json: JSON = JSON(response.result.value!)
                            let success = NetworkUtils().determineSuccess(code: code)

                            let status = NetworkCallStatus(failure: false, success: success, type: TaskType.POST_GET_FOR_HUB).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.result.error))")

                        let status = NetworkCallStatus(failure: true, success: false, type: TaskType.POST_GET_FOR_HUB)

                        self.onComplete(status: status)

                        break
                    }
                }
    }

    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
