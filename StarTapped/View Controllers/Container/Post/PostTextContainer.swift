//
//  PostTextContainer.swift
//  StarTapped
//
//  Created by Nova Maday on 1/16/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PostTextContainer: UIView {
    @IBOutlet weak var contentView: UIView!
    
    //Top bar
    @IBOutlet weak var blogUrlLatest: UIButton!
    @IBOutlet weak var reblogIcon: UIImageView!
    @IBOutlet weak var blogUrlSecond: UIButton!
    
    //Post contents
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postText: UILabel!
    
    //Bottom bar
    @IBOutlet weak var sourceBlog: UIButton!
    @IBOutlet weak var bookmarkPost: UIButton!
    @IBOutlet weak var reblogPost: UIButton!
    
    var post: TextPost!
    var parent: Post?
    var jPost: JSON!
    var controller: UIViewController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("PostTextContainer", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func configure(post: TextPost, jPost: JSON) {
        self.post = post
        self.parent = nil
        self.jPost = jPost
        
        //top bar
        blogUrlLatest.setTitle(post.getOriginBlog().getBaseUrl(), for: .normal)
        reblogIcon.isHidden = true
        blogUrlSecond.isHidden = true
        
        //Post contents
        postTitle.text = post.getTitle()
        postText.text = post.getBody()
        
        //Bottom bar
        sourceBlog.setTitle("Source \(post.getOriginBlog().getBaseUrl())", for: .normal)
    }
    
    func configure(post: TextPost, parent: Post, jPost: JSON) {
        self.post = post
        self.parent = parent
        self.jPost = jPost
        
        //Top bar
        blogUrlLatest.setTitle(post.getOriginBlog().getBaseUrl(), for: .normal)
        reblogIcon.isHidden = false
        blogUrlSecond.setTitle(parent.getOriginBlog().getBaseUrl(), for: .normal)
        blogUrlSecond.isHidden = false
        
        //Post contents
        postTitle.text = post.getTitle()
        postText.text = post.getBody()
        
        //Bottom bar
        sourceBlog.setTitle("Source \(post.getOriginBlog().getBaseUrl())", for: .normal)
    }
    
    func fixTheStupid() {
        blogUrlLatest.sizeToFit()
        blogUrlLatest.setNeedsDisplay()
        if parent != nil {
            blogUrlSecond.sizeToFit()
            blogUrlSecond.setNeedsDisplay()
        }
        postTitle.sizeToFit()
        postTitle.setNeedsDisplay()
        postText.sizeToFit()
        postText.setNeedsDisplay()
        
        sourceBlog.sizeToFit()
        sourceBlog.setNeedsDisplay()
        
        self.heightAnchor
            .constraint(equalToConstant: self.contentView.bounds.height)
            .isActive = true
        self.widthAnchor
            .constraint(equalToConstant: self.contentView.bounds.width)
            .isActive = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    @IBAction func onUrlLatestClick() {
        ViewUtils().goToViewBlog(view: self.controller, anim: true, blogId: post.getOriginBlog().getBlogId())
    }
    
    @IBAction func onUrlSecondClick() {
        if (parent != nil) {
            ViewUtils().goToViewBlog(view: self.controller, anim: true, blogId: (parent?.getOriginBlog().getBlogId())!)
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

