//
//  TextPost.swift
//  StarTapped
//
//  Created by Nova Maday on 1/6/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation

class TextPost: Post {
    //No specific properties at this time...

    override init(creator: Account, originBlog: Blog) {
        super.init(creator: creator, originBlog: originBlog)

        type = PostType.TEXT
    }
}
