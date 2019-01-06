//
//  ImagePost.swift
//  StarTapped
//
//  Created by Nova Maday on 1/6/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class ImagePost: Post {
    var imageUrl: String = "Undefined"

    override init(creator: Account, originBlog: Blog) {
        super.init(creator: creator, originBlog: originBlog)

        type = PostType.IMAGE
    }

    //Getters
    func getImageUrl() -> String {
        return imageUrl
    }

    //Setters
    func setImageUrl(imageUrl: String) {
        self.imageUrl = imageUrl
    }

    //JSON Handling
    override func toJson() -> JSON {
        var json = super.toJson()

        json["image_url"].string = imageUrl

        return json
    }

    override func fromJson(json: JSON) -> Post {
        super.fromJson(json: json)

        imageUrl = json["image_url"].stringValue

        return self
    }
}
