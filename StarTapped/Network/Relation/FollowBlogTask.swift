//
// Created by Nova Maday on 2019-01-07.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class FollowBlogTask: NetworkTask {
    var callback: TaskCallback

    let blogId: String

    init(callback: TaskCallback, blogId: String) {
        self.callback = callback
        self.blogId = blogId
    }

    func execute() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization_Access": Settings().getAuthentication().getAccessToken(),
            "Authorization_Refresh": Settings().getAuthentication().getRefreshToken()
        ]

        let params: [String: String] = [
            "blog_id": blogId
        ]

        AF.request("https://api.startapped.com/v1/relation/follow", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.value != nil {
                            //Get body
                            let json: JSON = JSON(response.value!)
                            let success = NetworkUtils().determineSuccess(code: code)

                            let status = NetworkCallStatus(failure: false, success: success, type: TaskType.FOLLOW_FOLLOW_BLOG).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.error))")

                        let status = NetworkCallStatus(failure: true, success: false, type: TaskType.FOLLOW_FOLLOW_BLOG)

                        self.onComplete(status: status)

                        break
                    }
                }
    }

    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
