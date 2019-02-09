//
// Created by Nova Maday on 2019-02-09.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class UploadedFile {
    var hash: String = "Undefined"
    var path: String = "Undefined"
    var url: String = "Undefined"
    var uploader: String = "Undefined"
    var name: String = "Undefined"
    var timestamp: Int64 = 0

    //Getters
    func getHash() -> String {
        return hash
    }

    func getPath() -> String {
        return path
    }

    func getUrl() -> String {
        return url
    }

    func getUploader() -> String {
        return uploader
    }

    func getName() -> String {
        return name
    }

    func getTimestamp() -> Int64 {
        return timestamp
    }

    //Setters
    func setHash(hash: String) {
        self.hash = hash
    }

    func setPath(path: String) {
        self.path = path
    }

    func setUrl(url: String) {
        self.url = url
    }

    func setUploader(uploader: String) {
        self.uploader = uploader
    }

    func setName(name: String) {
        self.name = name
    }

    func setTimestamp(timestamp: Int64) {
        self.timestamp = timestamp
    }

    //Functions
    func toJson() -> JSON {
        return [
            "hash": hash,
            "path": path,
            "url": url,
            "uploader": uploader,
            "name": name,
            "timestamp": timestamp
        ]
    }

    func fromJson(json: JSON) -> UploadedFile {

        hash = json["hash"].stringValue
        path = json["path"].stringValue
        url = json["url"].stringValue
        uploader = json["uploader"].stringValue
        name = json["name"].stringValue
        timestamp = json["timestamp"].int64Value

        return self
    }
}