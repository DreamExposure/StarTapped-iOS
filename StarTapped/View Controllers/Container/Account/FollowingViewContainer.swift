//
//  FollowingViewContainer.swift
//  StarTapped
//
//  Created by Nova Maday on 1/16/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class FollowingViewContainer: UIView, TaskCallback {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var urlView: UIButton!
    
    var blog: Blog!
    var jBlog: JSON!
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
        Bundle.main.loadNibNamed("FollowingViewContainer", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func configure(blog: Blog, jBlog: JSON) {
        self.blog = blog
        self.jBlog = jBlog
        
        //Do all the shit yay!
        self.urlView.setTitle(self.blog.getBaseUrl().lowercased(), for: .normal)
        
        DownloadImageTask(callback: self, url: self.blog.getIconUrl(), view: self.iconImage).execute()
    }
    
    func fixTheStupid() {
        self.heightAnchor
            .constraint(equalToConstant: self.contentView.bounds.height)
            .isActive = true
        self.widthAnchor
            .constraint(equalToConstant: self.contentView.bounds.width)
            .isActive = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func onBlogUrlClick() {
        ViewUtils().goToViewBlog(view: controller, anim: true, blogId: blog.getBlogId())
    }
    
    func onCallBack(status: NetworkCallStatus) {
        //Can savely ignore, its just for downloading images.
    }
}
