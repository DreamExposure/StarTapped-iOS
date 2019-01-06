//
//  AudioPost.swift
//  StarTapped
//
//  Created by Nova Maday on 1/6/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class AudioPost: Post {
    var audioUrl: String = "Undefined"

    override init(creator: Account, originBlog: Blog) {
        super.init(creator: creator, originBlog: originBlog)

        type = PostType.AUDIO
    }

    //Getters
    func getAudioUrl() -> String {
        return audioUrl
    }

    //Setters
    func setAudioUrl(audioUrl: String) {
        self.audioUrl = audioUrl
    }

    //JSON Handling
    override func toJson() -> JSON {
        var json = super.toJson()

        json["audio_url"].string = audioUrl

        return json
    }

    override func fromJson(json: JSON) -> Post {
        super.fromJson(json: json)

        audioUrl = json["audio_url"].stringValue

        return self
    }
}
