//
// Created by Nova Maday on 2019-01-07.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class UpdateBlogTask: NetworkTask {
    var callback: TaskCallback

    var backgroundPath: String = "Unassigned"
    var iconPath: String = "Unassigned"

    let blog: Blog

    init(callback: TaskCallback, blog: Blog) {
        self.callback = callback
        self.blog = blog
    }

    func execute() {
        let headers = [
            "Content-Type": "application/json",
            "Authorization_Access": Settings().getAuthentication().getAccessToken(),
            "Authorization_Refresh": Settings().getAuthentication().getRefreshToken()
        ]

        let params: [String: Any] = [
            "id": blog.getBlogId(),
            "name": blog.getName(),
            "description": blog.getDescription(),
            "nsfw": blog.isNsfw(),
            "allow_under18": blog.doesAllowUnder18(),
            "background_color": blog.getBackgroundColor()
        ]
        //TODO: Handle display age if personal blog
        //TODO: handle background image
        //TODO: Handle icon image

        Alamofire.request("https://api.startapped.com/v1/blog/update", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.result.value != nil {
                            print("success response : \(String(describing: response.result.value))")

                            //Get body
                            var json: JSON = JSON(response.result.value!)

                            let status = NetworkCallStatus(failure: false, success: true, type: TaskType.BLOG_UPDATE_SELF).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.result.error))")

                        let status = NetworkCallStatus(failure: true, success: false, type: TaskType.BLOG_UPDATE_SELF)

                        self.onComplete(status: status)

                        break
                    }
                }
    }

    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}