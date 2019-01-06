//
// Created by Nova Maday on 2019-01-05.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class PersonalBlog: Blog {
    var ownerId: String = "Unassigned"

    var displayAge: Bool = true

    override init() {
        super.init()

        blogType = BlogType.PERSONAL
    }

    //Getters
    func getOwnerId() -> String {
        return ownerId
    }

    func isDisplayAge() -> Bool {
        return displayAge
    }

    //Setters
    func setOwnerId(id: String) {
        self.ownerId = id
    }

    func setDisplayAge(display: Bool) {
        self.displayAge = display
    }

    //JSON Handling
    override func toJson() -> JSON {
        var json = super.toJson()

        json["owner_id"].string = ownerId
        json["display_age"].bool = displayAge

        return json
    }

    override func fromJson(json: JSON) -> Blog {
        super.fromJson(json: json)

        ownerId = json["owner_id"].stringValue
        displayAge = json["display_age"].boolValue

        return self
    }
}