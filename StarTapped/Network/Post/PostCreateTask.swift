//
// Created by Nova Maday on 2019-02-25.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class PostCreateTask: NetworkTask {
    var callback: TaskCallback
    var post: Post
    var media: [String: String]?


    init(callback: TaskCallback, post: Post) {
        self.callback = callback
        self.post = post
        self.media = nil
    }

    init(callback: TaskCallback, post: Post, media: [String: String]) {
        self.callback = callback
        self.post = post
        self.media = media
    }


    func execute() {
        let headers = [
            "Content-Type": "application/json",
            "Authorization_Access": Settings().getAuthentication().getAccessToken(),
            "Authorization_Refresh": Settings().getAuthentication().getRefreshToken()
        ]

        var params: [String: Any] = [
            "blog_id": post.getOriginBlog().getBlogId(),
            "type": post.getType().rawValue,
            "title": post.getTitle(),
            "body": post.getBody(),
            "nsfw": post.isNsfw()
        ]
        if post.getParent() != nil {
            params["parent"] = post.getParent()!
        }
        if !post.getTags().isEmpty {
            params["tags"] = post.getTags()
        }

        //Post media handling...
        switch (post.getType()) {
            case .IMAGE:
                params["image"] = media!
                break
            case .AUDIO:
                params["audio"] = media!
                break;
            case .VIDEO:
                params["video"] = media!
                break;
            default:
                //Doesn't need media...
                break;
        }

        Alamofire.request("https://api.startapped.com/v1/post/create", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON { response in
                    let code: Int = (response.response?.statusCode)!
                    switch (response.result) {
                    case .success(_):
                        if response.result.value != nil {
                            //Get body
                            let json: JSON = JSON(response.result.value!)
                            let success = NetworkUtils().determineSuccess(code: code)

                            let status = NetworkCallStatus(failure: false, success: success, type: TaskType.POST_CREATE).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)

                            self.onComplete(status: status)
                        }
                        break
                    case .failure(_):
                        //This is an internal error, NOT a 400 or 500 status code.
                        print("Failure : \(String(describing: response.result.error))")

                        let status = NetworkCallStatus(failure: true, success: false, type: TaskType.POST_CREATE)

                        self.onComplete(status: status)

                        break
                    }
                }
    }

    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
