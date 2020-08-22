//
//  AddBookmarkTask.swift
//  StarTapped
//
//  Created by Nova Maday on 3/6/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class AddBookmarkTask: NetworkTask {
    var callback: TaskCallback
    var postId: String
    
    
    init(callback: TaskCallback, postId: String) {
        self.callback = callback
        self.postId = postId
    }
    
    func execute() {
        let headers = [
            "Content-Type": "application/json",
            "Authorization_Access": Settings().getAuthentication().getAccessToken(),
            "Authorization_Refresh": Settings().getAuthentication().getRefreshToken()
        ]
        
        let params: [String: Any] = [
            "post_id": postId
        ]
        
        Alamofire.request("https://api.startapped.com/v1/post/bookmark/add", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                let code: Int = (response.response?.statusCode)!
                switch (response.result) {
                case .success(_):
                    if response.result.value != nil {
                        //Get body
                        let json: JSON = JSON(response.result.value!)
                        let success = NetworkUtils().determineSuccess(code: code)
                        
                        let status = NetworkCallStatus(failure: false, success: success, type: TaskType.BOOKMARK_ADD).setCode(code: code).setBody(body: json).setMessage(message: json["message"].stringValue)
                        
                        self.onComplete(status: status)
                    }
                    break
                case .failure(_):
                    //This is an internal error, NOT a 400 or 500 status code.
                    print("Failure : \(String(describing: response.result.error))")
                    
                    let status = NetworkCallStatus(failure: true, success: false, type: TaskType.BOOKMARK_ADD)
                    
                    self.onComplete(status: status)
                    
                    break
                }
        }
    }
    
    func onComplete(status: NetworkCallStatus) {
        callback.onCallBack(status: status)
    }
}
