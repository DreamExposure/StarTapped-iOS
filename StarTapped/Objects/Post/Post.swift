//
//  Post.swift
//  StarTapped
//
//  Created by Nova Maday on 1/5/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class Post {
    var id: String = "Undefined"
    var creator: Account?
    var originBlog: Blog?
    var permalink: String = "Undefined"
    var fullUrl: String = "Undefined"
    var type: PostType = PostType.TEXT
    var timestamp: Int64 = TimeUtils().getCurrentMillis()

    var title: String = "Undefined"
    var body: String = "Undefined"

    var nsfw: Bool = false

    var parent: String?

    //post type specifics
    var image: UploadedFile = UploadedFile()
    var audio: UploadedFile = UploadedFile()
    var video: UploadedFile = UploadedFile()

    init(creator: Account, originBlog: Blog) {
        self.creator = creator
        self.originBlog = originBlog
    }
    
    init() {
    }

    //Getters
    func getId() -> String {
        return id
    }

    func getCreator() -> Account {
        return creator!
    }

    func getOriginBlog() -> Blog {
        return originBlog!
    }

    func getPermalink() -> String {
        return permalink
    }

    func getFullUrl() -> String {
        return fullUrl
    }

    func getType() -> PostType {
        return type
    }

    func getTimestamp() -> Int64 {
        return timestamp
    }

    func getTitle() -> String {
        return title
    }

    func getBody() -> String {
        return body
    }

    func isNsfw() -> Bool {
        return nsfw
    }

    func getParent() -> String? {
        return parent
    }

    func getImage() -> UploadedFile {
        return image
    }

    func getAudio() -> UploadedFile {
        return audio
    }

    func getVideo() -> UploadedFile {
        return video
    }

    //Setters
    func setId(id: String) {
        self.id = id
    }

    func setCreator(creator: Account) {
        self.creator = creator
    }

    func setOriginBlog(blog: Blog) {
        self.originBlog = blog
    }

    func setPermalink(link: String) {
        self.permalink = link
    }

    func setFullUrl(url: String) {
        self.fullUrl = url
    }

    func setType(type: PostType) {
        self.type = type
    }

    func setTimestamp(timestamp: Int64) {
        self.timestamp = timestamp
    }

    func setTitle(title: String) {
        self.title = title
    }

    func setBody(body: String) {
        self.body = body
    }

    func setNsfw(nsfw: Bool) {
        self.nsfw = nsfw
    }

    func setParent(parent: String) {
        self.parent = parent
    }

    func setImage(image: UploadedFile) {
        self.image = image
    }

    func setAudio(audio: UploadedFile) {
        self.audio = audio
    }

    func setVideo(video: UploadedFile) {
        self.video = video
    }

    //JSON Handling
    func toJson() -> JSON {
        var json: JSON = [
            "id": id,
            "creator": creator!.toJson(),
            "origin_blog": originBlog!.toJson(),
            "permalink": permalink,
            "full_url": fullUrl,
            "timestamp": timestamp,
            "type": type.rawValue,
            "title": title,
            "body": body,
            "nsfw": nsfw,
            "parent": parent ?? "Unassigned"
            ]

        if self.type == .IMAGE {
            json["image"] = image.toJson()
        } else if self.type == .AUDIO {
            json["audio"] = audio.toJson()
        } else if self.type == .VIDEO {
            json["video"] = video.toJson()
        }

        return json
    }

    func fromJson(json: JSON) -> Post {
        id = json["id"].stringValue
        creator = Account().fromJson(json: json["creator"])
        originBlog = Blog().fromJson(json: json["origin_blog"])
        permalink = json["permalink"].stringValue
        fullUrl = json["full_url"].stringValue
        timestamp = json["timestamp"].int64Value
        type = PostType.init(rawValue: json["type"].stringValue)!
        title = json["title"].stringValue
        body = json["body"].stringValue
        nsfw = json["nsfw"].boolValue
        if let parent = json["parent"].string {
            self.parent = parent
        }

        if self.type == .IMAGE {
            image = UploadedFile().fromJson(json: json["image"])
        } else if self.type == .AUDIO {
            audio = UploadedFile().fromJson(json: json["audio"])
        } else if self.type == .VIDEO {
            video = UploadedFile().fromJson(json: json["video"])
        }

        return self
    }
}
