//
//  PostViewUtils.swift
//  StarTapped
//
//  Created by Nova Maday on 1/25/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PostViewUtils {
    func generatePostTreeView(lowest: Post, posts: [Post], controller: UIViewController) -> UIStackView {
        let root = UIStackView()
        root.translatesAutoresizingMaskIntoConstraints = false
        root.axis = .vertical
        root.distribution = .equalSpacing
        root.alignment = .center
        root.spacing = 0
        //Calling view controller will center this...

        var postsInOrder: [Post] = []

        var current: Post = lowest

        while (current.parent != nil) {
            let parent: Post? = ViewUtils().getPostFromArray(posts: posts, id: current.getParent()!)

            if parent != nil {
                postsInOrder.append(parent!)

                current = parent!
            } else {
                break
            }
        }
        //It should start with the highest parent and end with the second to last...

        var first: PostContainerBase?

        for p in postsInOrder {
            var v: PostContainerBase?

            if p.getType() == .TEXT {
                v = generateTextPostView(post: p, parent: nil, showTopBar: false, showBottomBar: false, showTags: false, controller: controller)
            } else if p.getType() == .IMAGE {
                v = generateImagePostView(post: p, parent: nil, showTopBar: false, showBottomBar: false, showTags: false, controller: controller)
            } else if p.getType() == .AUDIO {
                v = generateAudioPostView(post: p, parent: nil, showTopBar: false, showBottomBar: false, showTags: false, controller: controller)
            } else if p.getType() == .VIDEO {
                v = generateVideoPostView(post: p, parent: nil, showTopBar: false, showBottomBar: false, showTags: false, controller: controller)
            }

            if first == nil {
                first = v
            }

            root.addArrangedSubview(v!)
        }

        //Add bottom child...
        var child: PostContainerBase?

        if lowest.getType() == .TEXT {
            child = generateTextPostView(post: lowest, parent: nil, showTopBar: false, showBottomBar: true, showTags: true, controller: controller)
        } else if lowest.getType() == .IMAGE {
            child = generateImagePostView(post: lowest, parent: nil, showTopBar: false, showBottomBar: true, showTags: true, controller: controller)
        } else if lowest.getType() == .AUDIO {
            child = generateAudioPostView(post: lowest, parent: nil, showTopBar: false, showBottomBar: true, showTags: true, controller: controller)
        } else if lowest.getType() == .VIDEO {
            child = generateVideoPostView(post: lowest, parent: nil, showTopBar: false, showBottomBar: true, showTags: true, controller: controller)
        }
        root.addArrangedSubview(child!)

        if (first != nil) {
            first?.blogUrlLatest.setTitle(lowest.originBlog?.baseUrl, for: .normal)
            first?.blogUrlSecond.setTitle(postsInOrder[0].originBlog?.baseUrl, for: .normal)

            first?.blogUrlLatest.isHidden = false
            first?.blogUrlSecond.isHidden = false
            first?.reblogIcon.isHidden = false

            //Set the targets, no need to actually override the function itself.
            first?.blogUrlLatest.targetBlogId = lowest.originBlog?.blogId
            first?.blogUrlSecond.targetBlogId = postsInOrder[0].originBlog?.blogId

            //Make sure everything is displayed correctly since we changed some values.
            first?.fixTheStupid()
        }

        return root
    }
    
    func generateTextPostView(post: Post, parent: Post?, showTopBar: Bool, showBottomBar: Bool, showTags: Bool, controller: UIViewController) -> PostTextContainer {
        let root = PostTextContainer()

        if (parent == nil) {
            root.configure(post: post, controller: controller)
        } else {
            root.configure(post: post, parent: parent!, controller: controller)
        }

        //Handle some extra stuff...
        if (parent == nil) {
            root.reblogIcon.isHidden = true
            root.blogUrlSecond.isHidden = true
        }

        if (!showTopBar) {
            root.blogUrlLatest.isHidden = true
            root.blogUrlSecond.isHidden = true
            root.reblogIcon.isHidden = true
        }

        if (!showBottomBar) {
            root.sourceBlog.isHidden = true
            root.reblogPost.isHidden = true
            root.bookmarkPost.isHidden = true
        }
        if (!showTags || post.getTags().isEmpty || post.tagsToString().count <= 0 || post.tagsToString() == "") {
            root.tagDisplay.isHidden = true
            
            root.tagDisplay.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        root.fixTheStupid();

        return root;
    }
    
    func generateImagePostView(post: Post, parent: Post?, showTopBar: Bool, showBottomBar: Bool, showTags: Bool, controller: UIViewController) -> PostImageContainer {
        let root = PostImageContainer()

        if (parent == nil) {
            root.configure(post: post, controller: controller)
        } else {
            root.configure(post: post, parent: parent!, controller: controller)
        }

        //Handle some extra stuff...
        if (parent == nil) {
            root.reblogIcon.isHidden = true
            root.blogUrlSecond.isHidden = true
        }

        if (!showTopBar) {
            root.blogUrlLatest.isHidden = true
            root.blogUrlSecond.isHidden = true
            root.reblogIcon.isHidden = true
        }

        if (!showBottomBar) {
            root.sourceBlog.isHidden = true
            root.reblogPost.isHidden = true
            root.bookmarkPost.isHidden = true
        }
        if (!showTags || post.getTags().isEmpty || post.tagsToString().count <= 0 || post.tagsToString() == "") {
            root.tagDisplay.isHidden = true
            
            root.tagDisplay.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        root.fixTheStupid();

        return root;
    }
    
    func generateAudioPostView(post: Post, parent: Post?, showTopBar: Bool, showBottomBar: Bool, showTags: Bool, controller: UIViewController) -> PostAudioContainer {
        let root = PostAudioContainer()

        if (parent == nil) {
            root.configure(post: post, controller: controller)
        } else {
            root.configure(post: post, parent: parent!, controller: controller)
        }

        //Handle some extra stuff...
        if (parent == nil) {
            root.reblogIcon.isHidden = true
            root.blogUrlSecond.isHidden = true
        }

        if (!showTopBar) {
            root.blogUrlLatest.isHidden = true
            root.blogUrlSecond.isHidden = true
            root.reblogIcon.isHidden = true
        }

        if (!showBottomBar) {
            root.sourceBlog.isHidden = true
            root.reblogPost.isHidden = true
            root.bookmarkPost.isHidden = true
        }
        if (!showTags || post.getTags().isEmpty || post.tagsToString().count <= 0 || post.tagsToString() == "") {
            root.tagDisplay.isHidden = true
            
            root.tagDisplay.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        root.fixTheStupid();

        return root;
    }
    
    func generateVideoPostView(post: Post, parent: Post?, showTopBar: Bool, showBottomBar: Bool, showTags: Bool, controller: UIViewController) -> PostVideoContainer {
        let root = PostVideoContainer()

        if (parent == nil) {
            root.configure(post: post, controller: controller)
        } else {
            root.configure(post: post, parent: parent!, controller: controller)
        }

        //Handle some extra stuff...
        if (parent == nil) {
            root.reblogIcon.isHidden = true
            root.blogUrlSecond.isHidden = true
        }

        if (!showTopBar) {
            root.blogUrlLatest.isHidden = true
            root.blogUrlSecond.isHidden = true
            root.reblogIcon.isHidden = true
        }

        if (!showBottomBar) {
            root.sourceBlog.isHidden = true
            root.reblogPost.isHidden = true
            root.bookmarkPost.isHidden = true
        }
        if (!showTags || post.getTags().isEmpty || post.tagsToString().count <= 0 || post.tagsToString() == "") {
            root.tagDisplay.isHidden = true
            
            root.tagDisplay.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }

        root.fixTheStupid();

        return root;
    }
}
