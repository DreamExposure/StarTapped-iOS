//
//  TaskType.swift
//  StarTapped
//
//  Created by Nova Maday on 1/6/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation

enum TaskType: String {
    case ACCOUNT_GET_BLOG, ACCOUNT_GET_SELF, ACCOUNT_UPDATE,

         AUTH_LOGIN, AUTH_LOGOUT, AUTH_REGISTER, AUTH_TOKEN_REAUTH,

         BLOG_CREATE, BLOG_GET_SELF_EDIT, BLOG_GET_SELF_ALL, BLOG_UPDATE_SELF, BLOG_GET_VIEW,

         DOWNLOAD_IMAGE,

         FOLLOW_FOLLOW_BLOG, FOLLOW_UNFOLLOW_BLOG, FOLLOW_GET_FOLLOWERS, FOLLOW_GET_FOLLOWING
}
