//
// Created by Nova Maday on 2019-01-05.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class Blog {
    var blogId: String = "Unassigned"

    var baseUrl: String = "Unassigned"
    var completeUrl: String = "Unassigned"

    var blogType: BlogType = BlogType.PERSONAL

    var name: String = "Unassigned"
    var description: String = "Unassigned"

    var iconUrl: String = "Unassigned"
    var backgroundColor: String = "Unassigned"
    var backgroundUrl: String = "Unassigned"

    var allowUnder18: Bool = true
    var nsfw: Bool = false

    var followers: [String] = [String]()

    //Getters
    func getBlogId() -> String {
        return blogId
    }

    func getBaseUrl() -> String {
        return baseUrl
    }

    func getCompleteUrl() -> String {
        return completeUrl
    }

    func getBlogType() -> BlogType {
        return blogType
    }

    func getName() -> String {
        return name
    }

    func getDescription() -> String {
        return description
    }

    func getIconUrl() -> String {
        return iconUrl
    }

    func getBackgroundColor() -> String {
        return backgroundColor
    }

    func doesAllowUnder18() -> Bool {
        return allowUnder18
    }

    func isNsfw() -> Bool {
        return nsfw
    }

    func getFollowers() -> [String] {
        return followers
    }

    //Setters
    func setBlogId(blogId: String) {
        self.blogId = blogId
    }

    func setBaseUrl(url: String) {
        self.baseUrl = url
    }

    func setCompleteUrl(url: String) {
        self.completeUrl = url
    }

    func setBlogType(type: BlogType) {
        self.blogType = type
    }

    func setName(name: String) {
        self.name = name
    }

    func setDescription(desc: String) {
        self.description = desc
    }

    func setIconUrl(icon: String) {
        self.iconUrl = icon
    }

    func setBackgroundColor(color: String) {
        self.backgroundColor = color
    }

    func setBackgroundUrl(url: String) {
        self.backgroundUrl = url
    }

    func setAllowUnder18(allow: Bool) {
        self.allowUnder18 = allow
    }

    func setNsfw(nsfw: Bool) {
        self.nsfw = nsfw
    }

    //JSON Handling
    func toJson() -> JSON {
        return [
            "id": blogId,
            "base_url": baseUrl,
            "complete_url": completeUrl,
            "type": blogType.rawValue,
            "name": name,
            "description": description,
            "icon_url": iconUrl,
            "background_color": backgroundColor,
            "background_url": backgroundUrl,
            "allow_under_18": allowUnder18,
            "nsfw": nsfw,
            "followers": followers
        ]
    }

    func fromJson(json: JSON) -> Blog {
        self.blogId = json["id"].stringValue
        self.baseUrl = json["base_url"].stringValue
        self.completeUrl = json["complete_url"].stringValue
        self.blogType = BlogType(rawValue: json["type"].stringValue)!
        self.name = json["name"].stringValue
        self.description = json["description"].stringValue
        self.iconUrl = json["icon_url"].stringValue
        self.backgroundColor = json["background_color"].stringValue
        self.backgroundUrl = json["background_url"].stringValue
        self.allowUnder18 = json["allow_under_18"].boolValue
        self.nsfw = json["nsfw"].boolValue
        self.followers = json["followers"].arrayValue.map({ $0[].stringValue })

        return self
    }
}
