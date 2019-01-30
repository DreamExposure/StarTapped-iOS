//
//  BlogViewContainer.swift
//  StarTapped
//
//  Created by Nova Maday on 1/13/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class BlogViewContainer: UIView, TaskCallback {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogDescription: UILabel!
    
    @IBOutlet weak var nsfwBadge: UILabel!
    @IBOutlet weak var noMinorsBadge: UILabel!
    @IBOutlet weak var ageBadge: UILabel!
    
    var blog: Blog!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("BlogView", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func configure(blog: Blog) {
        self.blog = blog
        
        //Do all the shit yay!
        self.blogTitle.text = self.blog.getName()
        self.blogDescription.text = self.blog.getDescription()
        
        self.nsfwBadge.isHidden = !self.blog.isNsfw()
        self.noMinorsBadge.isHidden = self.blog.doesAllowUnder18()
        
        if (self.blog.getBlogType() == BlogType.PERSONAL) {
            if (self.blog.isDisplayAge()) {
                GetAccountForBlogViewTask(callback: self, id: self.blog.getOwnerId()).execute()
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
    
    func onCallBack(status: NetworkCallStatus) {
        if (status.getType() == .ACCOUNT_GET_BLOG && status.isSuccess()) {
            let acc = Account().fromJson(json: status.getBody()["account"])
            self.ageBadge.text = "\(TimeUtils().calculateAge(ageString: acc.getBirthday()))"
        }
    }
}
