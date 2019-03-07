//
// Created by Nova Maday on 2019-01-28.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import FRHyperLabel
import TTGTagCollectionView

class PostContainerBase: UIView, TTGTextTagCollectionViewDelegate, TaskCallback {
    @IBOutlet weak var contentView: UIView!
    
    //Top bar
    @IBOutlet weak var blogUrlLatest: BlogUrlButton!
    @IBOutlet weak var reblogIcon: UIImageView!
    @IBOutlet weak var blogUrlSecond: BlogUrlButton!

    //Post contents
    @IBOutlet weak var postTitle: FRHyperLabel!
    @IBOutlet weak var postText: FRHyperLabel!

    //Tags
    @IBOutlet weak var tagDisplay: TTGTextTagCollectionView!
    
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
    
    func configureTags() {
        //Configure tag container
        tagDisplay.scrollDirection = .horizontal
        tagDisplay.numberOfLines = 1
        tagDisplay.selectionLimit = 1
        
        tagDisplay.delegate = self
        
        //Create tag config
        let tagConfig = TTGTextTagConfig()
        tagConfig.textColor = ViewUtils().hexStringToUIColor(hex: "#4e5f85")
        tagConfig.backgroundColor = ViewUtils().hexStringToUIColor(hex: "#adb5bd")
        
        //Add tags to tag container
        for t in post.getTags() {
            if t.count > 0 && t != "" {
                let tagText = "#\(t.trimmingCharacters(in: .whitespacesAndNewlines))"
                
                tagDisplay.addTag(tagText, with: tagConfig)
            }
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
        if (post.isBookmarked()) {
            RemoveBookmarkTask(callback: self, postId: post.getId()).execute()
        } else {
            AddBookmarkTask(callback: self, postId: post.getId()).execute()
        }
    }
    
    func textTagCollectionView(_ textTagCollectionView: TTGTextTagCollectionView!, didTapTag tagText: String!, at index: UInt, selected: Bool, tagConfig config: TTGTextTagConfig!) {
        var textFor: String = tagText
        if tagText.starts(with: "#") {
            textFor = String(tagText[1..<tagText.count])
        }
        
        if self.controller is SearchViewController {
            //Already in search view controller, just change current tags and tell it to do a new search...
            let search = self.controller as! SearchViewController
            
            search.index = TimeIndex()
            search.clear = true
            search.stopRequesting = false
            
            search.currentTags.removeAll()
            
            search.currentTags.append(textFor.trimmingCharacters(in: .whitespacesAndNewlines))
            
            search.searchBar.text = textFor
            
            search.getPosts()
        } else {
            //Get search controller
            let tabBar: UITabBarController? = self.controller.tabBarController
            let search = tabBar?.viewControllers![2].children[0] as! SearchViewController
        
            search.searchOnDisplay = true
            search.currentTags.removeAll()
            search.currentTags.append(textFor.trimmingCharacters(in: .whitespacesAndNewlines))
            
            //Switch to search
            self.controller.tabBarController?.selectedIndex = 2;
            
            //Unwind if needed...
            search.navigationController?.popToRootViewController(animated: true)
            
            //Would search but our viewDidAppear() in the search controller will handle it.
        }
        
        self.tagDisplay.setTagAt(index, selected: false)
    }
    
    func onCallBack(status: NetworkCallStatus) {
        switch (status.getType()) {
        case .BOOKMARK_ADD:
            if status.isSuccess() {
                post.setBookmarked(bookmarked: true)
            }
            self.controller.view.makeToast(status.getMessage())
            break
        case .BOOKMARK_REMOVE:
            if status.isSuccess() {
                post.setBookmarked(bookmarked: false)
            }
            self.controller.view.makeToast(status.getMessage())
            break
        default:
            break
        }
    }
}
