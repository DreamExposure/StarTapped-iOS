//
//  BookmarksViewController.swift
//  StarTapped
//
//  Created by Nova Maday on 3/6/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import Popover
import SwiftyJSON
import Toast_Swift

class BookmarksViewController: UIViewController, UIScrollViewDelegate, TaskCallback {
    @IBOutlet weak var scrollView: UIScrollView!
    var stackView: UIStackView!
    var refreshControl: UIRefreshControl!
    
    var index: TimeIndex!
    var isGenerating = false
    var isRefreshing = false
    var stopRequesting = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupVerticalScrollingStack()
        
        self.scrollView.delegate = self
        self.scrollView.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        index = TimeIndex()
        
        getPosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func didPullToRefresh() {
        refresh()
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getPostsCallback(status: NetworkCallStatus) {
        if (status.isSuccess()) {
            let jPosts: [JSON] = status.getBody()["posts"].arrayValue
            var posts: [Post] = ViewUtils().getPostsFromJsonArray(jPosts: jPosts)
            posts.sort(by: {$0.timestamp > $1.timestamp})
            
            if (posts.isEmpty) {
                stopRequesting = true
                self.view.makeToast("There's no more posts.")
            }
            
            let range = status.getBody()["range"]
            if (range["latest"].int64Value > 0) {
                index.setLatest(latest: range["latest"].int64Value)
                index.setOldest(oldest: range["oldest"].int64Value)
            }
            
            if (isRefreshing) {
                self.stackView.removeAllArrangedViews()
            }
            
            for p in posts {
                //Skip posts not in range. Probably a parent post which will be handled correctly.
                if (p.timestamp >= index.getOldest() && p.timestamp <= index.getLatest() && p.isBookmarked()) {
                    if (p.getParent() != nil) {
                        let view = PostViewUtils().generatePostTreeView(lowest: p, posts: posts, controller: self)
                        
                        self.stackView.addArrangedSubview(view)
                        view.centerXAnchor.constraint(equalTo: self.stackView.centerXAnchor).isActive = true
                    } else {
                        if p.getType() == .TEXT {
                            //Handle single post (no parent)
                            let view = PostViewUtils().generateTextPostView(post: p, parent: nil, showTopBar: true, showBottomBar: true, showTags: true, controller: self)
                            
                            self.stackView.addArrangedSubview(view)
                        } else if p.getType() == .IMAGE {
                            //Handle single post (no parent)
                            let view = PostViewUtils().generateImagePostView(post: p, parent: nil, showTopBar: true, showBottomBar: true, showTags: true, controller: self)
                            
                            self.stackView.addArrangedSubview(view)
                        } else if p.getType() == .AUDIO {
                            //Handle single post (no parent)
                            let view = PostViewUtils().generateAudioPostView(post: p, parent: nil, showTopBar: true, showBottomBar: true, showTags: true, controller: self)
                            
                            self.stackView.addArrangedSubview(view)
                        } else if p.getType() == .VIDEO {
                            //Handle single post (no parent)
                            let view = PostViewUtils().generateVideoPostView(post: p, parent: nil, showTopBar: true, showBottomBar: true, showTags: true, controller: self)
                            
                            self.stackView.addArrangedSubview(view)
                        }
                    }
                }
            }
        } else {
            if (status.getCode() == 417) {
                self.view.makeToast("There's no more posts.")
                stopRequesting = true
            } else {
                self.view.makeToast(status.getMessage())
            }
        }
        isGenerating = false
        
        if (isRefreshing) {
            isRefreshing = false
            refreshControl.endRefreshing()
        }
        
        index.setBefore(before: index.getOldest() - 1)
    }
    
    func getPosts() {
        if !isGenerating && !stopRequesting {
            isGenerating = true
            
            let task = GetBookmarkedPostsTask(callback: self, index: index)
            task.execute()
        }
    }
    
    func refresh() {
        if !isRefreshing && !isGenerating {
            isRefreshing = true
            stopRequesting = false
            
            index = TimeIndex()
            
            getPosts()
        }
    }
    
    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .POST_GET_BOOKMARKED:
            getPostsCallback(status: status)
            break
        default:
            break
        }
    }
    
    func setupVerticalScrollingStack() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 30
        scrollView.addSubview(stackView)
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        //Center content horizontally
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            //At bottom...
            getPosts()
        }
    }
}
