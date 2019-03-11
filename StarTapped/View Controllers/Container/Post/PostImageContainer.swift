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
import PopupDialog

class PostImageContainer: PostContainerBase {
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
        super.configureText()
        
        //Tags
        super.configureTags()
        
        DownloadImageTask(callback: self, url: post.getImage().getUrl(), view: postImage).execute()
        
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
        super.configureText()
        
        //Tags
        super.configureTags()
        
        DownloadImageTask(callback: self, url: post.getImage().getUrl(), view: postImage).execute()
        
        //Bottom bar
        sourceBlog.setTitle("Source: \(post.getOriginBlog().getBaseUrl())", for: .normal)

        super.configureUrlButtons()
    }
    
    @IBAction func imageClicked(_ sender: Any) {
        
        let popup = PopupDialog(title: nil, message: nil, image: postImage.image)

        let close = CancelButton(title: "Close") {}
        
        popup.addButtons([close])
        
        popup.transitionStyle = .zoomIn
        
        self.controller.present(popup, animated: true, completion: nil)
    }
}
