//
//  VideoPost.swift
//  StarTapped
//
//  Created by Nova Maday on 1/6/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class VideoPost: Post {
    var videoUrl: String = "Undefined"

    override init(creator: Account, originBlog: Blog) {
        super.init(creator: creator, originBlog: originBlog)

        type = PostType.VIDEO
    }

    //Getters
    func getVideoUrl() -> String {
        return videoUrl
    }

    //Setters
    func setVideoUrl(videoUrl: String) {
        self.videoUrl = videoUrl
    }

    //JSON Handling
    override func toJson() -> JSON {
        var json = super.toJson()

        json["video_url"].string = videoUrl

        return json
    }

    override func fromJson(json: JSON) -> Post {
        super.fromJson(json: json)

        videoUrl = json["videoUrl"].stringValue

        return self
    }
}
