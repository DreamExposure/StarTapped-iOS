//
// Created by Nova Maday on 2019-01-05.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import SwiftyJSON

class GroupBlog: Blog {
    var owners: [String] = [String]()

    override init() {
        super.init()

        blogType = BlogType.GROUP
    }

    //Getters
    func getOwners() -> [String] {
        return owners
    }

    //JSON Handling
    override func toJson() -> JSON {
        var json = super.toJson()

        json["owners"].arrayObject = owners

        return json
    }

    override func fromJson(json: JSON) -> Blog {
        super.fromJson(json: json)

        owners = json["owners"].arrayValue.map({ $0[].stringValue })

        return self
    }
}
