//
// Created by Nova Maday on 2019-01-28.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit

class PostContainerBase: UIView {
    @IBOutlet weak var contentView: UIView!
    
    //Top bar
    @IBOutlet weak var blogUrlLatest: BlogUrlButton!
    @IBOutlet weak var reblogIcon: UIImageView!
    @IBOutlet weak var blogUrlSecond: BlogUrlButton!

    //Post contents
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postText: UILabel!

    //Bottom bar
    @IBOutlet weak var sourceBlog: UIButton!
    @IBOutlet weak var bookmarkPost: UIButton!
    @IBOutlet weak var reblogPost: UIButton!

    var post: Post!
    var parent: Post?
    var controller: UIViewController!

    func configureUrlButtons() {
        blogUrlLatest.targetBlogId = post.originBlog?.blogId

        if (parent != nil) {
            blogUrlSecond.targetBlogId = parent?.getOriginBlog().getBlogId()
        }
    }

    func fixTheStupid() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.layoutIfNeeded()
        
        self.heightAnchor
            .constraint(equalToConstant: self.contentView.frame.height)
            .isActive = true
        self.widthAnchor
            .constraint(equalToConstant: self.contentView.frame.width)
            .isActive = true
        
        self.layoutIfNeeded()
    }

    @IBAction func onUrlLatestClick() {
        ViewUtils().goToViewBlog(view: self.controller, anim: true, blogId: blogUrlLatest.targetBlogId!)
    }

    @IBAction func onUrlSecondClick() {
        if (blogUrlSecond.targetBlogId != nil) {
            ViewUtils().goToViewBlog(view: self.controller, anim: true, blogId: blogUrlSecond.targetBlogId!)
        }
    }

    @IBAction func onSourceBlogClick() {
        ViewUtils().goToViewBlog(view: self.controller, anim: true, blogId: post.getOriginBlog().getBlogId())
    }

    @IBAction func onReblogPostClick() {
        //TODO: Handle reblog click
    }

    @IBAction func onBookmarkPostClick() {
        //TODO: Handle bookmark click
    }
}
