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

    let icon: [String: String]?
    let background: [String:String]?

    init(callback: TaskCallback, blog: Blog, icon: [String:String]?, background: [String:String]?) {
        self.callback = callback
        self.blog = blog
        self.icon = icon
        self.background = background
    }

    func execute() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization_Access": Settings().getAuthentication().getAccessToken(),
            "Authorization_Refresh": Settings().getAuthentication().getRefreshToken()
        ]

        var params: [String: Any] = [
            "id": blog.getBlogId(),
            "name": blog.getName(),
            "description": blog.getDescription(),
            "nsfw": blog.isNsfw(),
            "allow_under_18": blog.doesAllowUnder18(),
            "background_color": blog.getBackgroundColor()
        ]

        if blog.getBlogType() == .PERSONAL {
            params["display_age"] = blog.isDisplayAge()
        }

        if self.icon != nil {
            params["icon_image"] = self.icon!
        }
        if self.background != nil {
            params["background_image"] = self.background!
        }

        AF.request("https://api.startapped.com/v1/blog/update", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.value != nil {
                            //Get body
                            let json: JSON = JSON(response.value!)
                            let success = NetworkUtils().determineSuccess(code: code)

                            let status = NetworkCallStatus(failure: false, success: success, type: TaskType.BLOG_UPDATE_SELF).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.error))")

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
