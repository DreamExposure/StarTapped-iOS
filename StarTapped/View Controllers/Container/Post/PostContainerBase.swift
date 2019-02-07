//
// Created by Nova Maday on 2019-01-28.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import FRHyperLabel

class PostContainerBase: UIView {
    @IBOutlet weak var contentView: UIView!
    
    //Top bar
    @IBOutlet weak var blogUrlLatest: BlogUrlButton!
    @IBOutlet weak var reblogIcon: UIImageView!
    @IBOutlet weak var blogUrlSecond: BlogUrlButton!

    //Post contents
    @IBOutlet weak var postTitle: FRHyperLabel!
    @IBOutlet weak var postText: FRHyperLabel!

    //Bottom bar
    @IBOutlet weak var sourceBlog: UIButton!
    @IBOutlet weak var bookmarkPost: UIButton!
    @IBOutlet weak var reblogPost: UIButton!

    var post: Post!
    var parent: Post?
    var controller: UIViewController!

    func configureText() {
        postTitle.numberOfLines = 0
        postText.numberOfLines = 0
        
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: ViewUtils().hexStringToUIColor(hex: "#b5532d"),
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        let bodyAttributes = [
            NSAttributedString.Key.foregroundColor: ViewUtils().hexStringToUIColor(hex: "#1F2635"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        postTitle.attributedText = NSAttributedString(string: post.getTitle(), attributes: titleAttributes)
        postText.attributedText = NSAttributedString(string: post.getBody(), attributes: bodyAttributes)
        
        
        //Handler
        let handler = {
            (hyperLabel: FRHyperLabel?, substring: String?) -> Void in
            if let url = URL(string: substring!) {
                if (UIApplication.shared.canOpenURL(url)) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        }
        
        //Substrings
        let titleLinks = Validator().getUrlSubStrings(input: post.getTitle())
        let bodyLinks = Validator().getUrlSubStrings(input: post.getBody())
        
        postTitle.setLinksForSubstrings(titleLinks, withLinkHandler: handler)
        postText.setLinksForSubstrings(bodyLinks, withLinkHandler: handler)
    }
    
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
