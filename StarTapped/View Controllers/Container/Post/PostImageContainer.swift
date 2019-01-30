//
//  PostImageContainer.swift
//  StarTapped
//
//  Created by Nova Maday on 1/16/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PostImageContainer: PostContainerBase, TaskCallback {
    //Post contents
    @IBOutlet weak var postImage: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("PostImageContainer", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func configure(post: Post, controller: UIViewController) {
        self.post = post
        self.parent = nil
        self.controller = controller
        
        //top bar
        blogUrlLatest.setTitle(post.getOriginBlog().getBaseUrl(), for: .normal)
        reblogIcon.isHidden = true
        blogUrlSecond.isHidden = true
        
        //Post contents
        postTitle.text = post.getTitle()
        postText.text = post.getBody()
        
        DownloadImageTask(callback: self, url: post.getImageUrl(), view: postImage).execute()
        
        //Bottom bar
        sourceBlog.setTitle("Source \(post.getOriginBlog().getBaseUrl())", for: .normal)

        super.configureUrlButtons()
    }
    
    func configure(post: Post, parent: Post, controller: UIViewController) {
        self.post = post
        self.parent = parent
        self.controller = controller
        
        //Top bar
        blogUrlLatest.setTitle(post.getOriginBlog().getBaseUrl(), for: .normal)
        reblogIcon.isHidden = false
        blogUrlSecond.setTitle(parent.getOriginBlog().getBaseUrl(), for: .normal)
        blogUrlSecond.isHidden = false
        
        //Post contents
        postTitle.text = post.getTitle()
        postText.text = post.getBody()
        
        DownloadImageTask(callback: self, url: post.getImageUrl(), view: postImage).execute()
        
        //Bottom bar
        sourceBlog.setTitle("Source: \(post.getOriginBlog().getBaseUrl())", for: .normal)

        super.configureUrlButtons()
    }
    
    override func fixTheStupid() {
        super.fixTheStupid()
    }
    

    func onCallBack(status: NetworkCallStatus) {
        //Can safely ignore, its just for downloading images.
    }
}
