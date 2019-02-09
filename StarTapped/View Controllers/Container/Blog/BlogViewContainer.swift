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
import FRHyperLabel

class BlogViewContainer: UIView, TaskCallback {
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var iconImage: UIImageView!
    
    @IBOutlet weak var blogTitle: FRHyperLabel!
    @IBOutlet weak var blogDescription: FRHyperLabel!
    
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
        configureText()
        
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
        
        DownloadImageTask(callback: self, url: self.blog.getIconImage().getUrl(), view: self.iconImage).execute()
        DownloadImageTask(callback: self, url: self.blog.getBackgroundImage().getUrl(), view: self.backgroundImage).execute()
    }
    
    func configureText() {
        blogTitle.numberOfLines = 0
        blogDescription.numberOfLines = 0
        
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: ViewUtils().hexStringToUIColor(hex: "#b5532d"),
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        
        let descAttributes = [
            NSAttributedString.Key.foregroundColor: ViewUtils().hexStringToUIColor(hex: "#1F2635"),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        blogTitle.attributedText = NSAttributedString(string: blog.getName(), attributes: titleAttributes)
        blogDescription.attributedText = NSAttributedString(string: blog.getDescription(), attributes: descAttributes)
        
        
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
        let titleLinks = Validator().getUrlSubStrings(input: blog.getName())
        let descLinks = Validator().getUrlSubStrings(input: blog.getDescription())
        
        blogTitle.setLinksForSubstrings(titleLinks, withLinkHandler: handler)
        blogDescription.setLinksForSubstrings(descLinks, withLinkHandler: handler)
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
