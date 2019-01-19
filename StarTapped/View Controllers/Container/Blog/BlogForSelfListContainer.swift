//
//  BlogForSelfListContainer.swift
//  StarTapped
//
//  Created by Nova Maday on 1/12/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class BlogForSelfListConainer: UIView, TaskCallback {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var edtButton: UIButton!
    @IBOutlet weak var urlView: UIButton!
    
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogDescription: UILabel!
    
    @IBOutlet weak var nsfwBadge: UILabel!
    @IBOutlet weak var noMinorsBadge: UILabel!
    @IBOutlet weak var ageBadge: UILabel!
    
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
        Bundle.main.loadNibNamed("BlogForSelfList", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func configure(blog: Blog, jBlog: JSON) {
        self.blog = blog
        self.jBlog = jBlog
    
        //Do all the shit yay!
        self.urlView.setTitle(self.blog.getBaseUrl().lowercased(), for: .normal)
        self.blogTitle.text = self.blog.getName()
        self.blogDescription.text = self.blog.getDescription()
        
        self.nsfwBadge.isHidden = !self.blog.isNsfw()
        self.noMinorsBadge.isHidden = self.blog.doesAllowUnder18()
        
        if (self.blog.getBlogType() == BlogType.PERSONAL) {
            let pBlog:PersonalBlog = PersonalBlog().fromJson(json: self.jBlog)
            if (pBlog.isDisplayAge()) {
                self.ageBadge.text = "\(TimeUtils().calculatAge(ageString: Settings().getAccount().getBirthday()))"
                self.ageBadge.isHidden = false
            } else {
                self.ageBadge.isHidden = true
            }
        } else {
            self.ageBadge.isHidden = true
        }
        
        self.contentView.backgroundColor = ViewUtils().hexStringToUIColor(hex: self.blog.getBackgroundColor())
        
        DownloadImageTask(callback: self, url: self.blog.getIconUrl(), view: self.iconImage).execute()
        DownloadImageTask(callback: self, url: self.blog.getBackgroundUrl(), view: self.backgroundImage).execute()
    }
    
    func fixTheStupid() {
        blogTitle.sizeToFit()
        blogTitle.setNeedsDisplay()
        blogDescription.sizeToFit()
        blogDescription.setNeedsDisplay()
        
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
    
    @IBAction func onEditButtonClick() {
        //TODO: Load blog edit view
    }
    
    func onCallBack(status: NetworkCallStatus) {
        //Can savely ignore, its just for downloading images.
    }
}
