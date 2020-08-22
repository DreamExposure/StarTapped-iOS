//
//  BlogViewController.swift
//  StarTapped
//
//  Created by Nova Maday on 1/14/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import SwiftyJSON
import Popover

class BlogViewController: UIViewController, UIScrollViewDelegate, TaskCallback {
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarTitle:  UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var stackView: UIStackView!
    var refreshControl: UIRefreshControl!
    
    var blogId: String!
    var index: TimeIndex!
    var isGenerating = false
    var isRefreshing = false
    var stopRequesting = false
    var blockOn = false

    var blog: Blog!
    
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.auto),
        .blackOverlayColor(UIColor(red:0.12, green:0.15, blue:0.21, alpha:0.6))
    ]
    fileprivate var texts = ["Followers", "Follow", "Unfollow", "Report", "Block", "Unblock"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.index = TimeIndex()
        
        self.setupVerticalScrollingStack()
        
        self.scrollView.delegate = self
        self.scrollView.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get blog
        GetBlogViewTask(callback: self, blogId: self.blogId).execute()
    }
    
    @objc func didPullToRefresh() {
        refresh()
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        //Go to previous view...
        self.navigationController?.popViewController(animated: true)
    }
    
    func displayBlog(status: NetworkCallStatus) {
        blog = Blog().fromJson(json: status.getBody()["blog"])
        toolbarTitle.title = blog.getBaseUrl()

        //TODO: Figure out check for blocked.
        if blog.isNsfw() && Settings().getAccount().isSafeSearch() {
            //NSFW blog with Safe Search on, show block.
            blockOn = true
            let blockMessage: NsfwBlogBlock = NsfwBlogBlock()
            blockMessage.controller = self
            blockMessage.fixTheStupid()

            texts.removeAll()
            
            self.stackView.addArrangedSubview(blockMessage)
        } else if !blog.allowUnder18 && TimeUtils().calculateAge(ageString: Settings().getAccount().getBirthday()) < 18 {
            //Blog does not allow minors and user is minor
            blockOn = true
            let blockMessage: AdultOnlyBlock = AdultOnlyBlock()
            blockMessage.controller = self
            blockMessage.fixTheStupid()

            texts.removeAll()
            
            self.stackView.addArrangedSubview(blockMessage)
        } else {
            let blogCon: BlogViewContainer = BlogViewContainer()
            
            blogCon.configure(blog: blog)
            
            blogCon.fixTheStupid()
            
            self.stackView.addArrangedSubview(blogCon)

            if blog.getOwnerId() == Settings().getAccount().getAccountId() || blog.getOwners().contains(Settings().getAccount().getAccountId()) {
                //Owns blog...
                texts.removeAll {
                    $0 == "Follow"
                }
                texts.removeAll {
                    $0 == "Unfollow"
                }
                texts.removeAll {
                    $0 == "Report"
                }
                texts.removeAll {
                    $0 == "Block"
                }
                texts.removeAll {
                    $0 == "Unblock"
                }
            } else if blog.getFollowers().contains(Settings().getAccount().getAccountId()) {
                //User is following blog
                texts.removeAll {
                    $0 == "Followers"
                }
                texts.removeAll {
                    $0 == "Follow"
                }
                texts.removeAll {
                    $0 == "Unblock"
                }
            } else {
                //User is not following blog and has not blocked blog
                texts.removeAll {
                    $0 == "Followers"
                }
                texts.removeAll {
                    $0 == "Unfollow"
                }
                texts.removeAll {
                    $0 == "Unblock"
                }
            }

            self.getPosts()
        }
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
                self.stackView.removeArrangedViewsWithOffset(offset: 1) //Should skip blog header
            }

            for p in posts {
                //Skip posts not in range. Probably a parent post which will be handled correctly.
                if (p.timestamp >= index.getOldest() && p.timestamp <= index.getLatest() && p.originBlog?.blogId == self.blogId) {
                    if (p.getParent() != nil) {
                        let view = PostViewUtils().generatePostTreeView(lowest: p, posts: posts, controller: self)
                        
                        self.stackView.addArrangedSubview(view)
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
        if !isGenerating && !stopRequesting && !blockOn {
            isGenerating = true

            let task = GetPostsForBlogTask(callback: self, id: blogId, index: index)
            task.execute()
        }
    }

    func refresh() {
        if !isRefreshing && !isGenerating && !blockOn {
            isRefreshing = true
            stopRequesting = false

            index = TimeIndex()

            getPosts()
        }
    }

    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .BLOG_GET_VIEW:
            if (status.isSuccess()) {
                self.displayBlog(status: status)
            } else {
                self.view.makeToast(status.getMessage())
            }
            break
        case .POST_GET_FOR_BLOG:
            self.getPostsCallback(status: status)
            break
        case .FOLLOW_FOLLOW_BLOG:
            if (status.isSuccess()) {
                self.view.makeToast("Success!")
                texts.removeAll {
                    $0 == "Follow"
                }
                texts.insert("Unfollow", at: 0)
            } else {
                self.view.makeToast(status.getMessage())
            }
            break
        case .FOLLOW_UNFOLLOW_BLOG:
            if (status.isSuccess()) {
                self.view.makeToast("Success!")
                texts.removeAll {
                    $0 == "Unfollow"
                }
                texts.insert("Follow", at: 0)
            } else {
                self.view.makeToast(status.getMessage())
            }
            break
        default:
            //Unsupported action
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
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView!]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView!]))
        
        //Center content horizontally
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            //At bottom...
            getPosts()
        }
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        //TODO: Handle share better, till then copy link to clipboard.
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = blog.getCompleteUrl()

        self.view.makeToast("Copied to clipboard!")
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let startPoint = CGPoint(x: self.view.frame.width - 60, y: 55)
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: CGFloat(42 * texts.count)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.popover = Popover(options: self.popoverOptions)
        self.popover.show(tableView, point: startPoint)
    }
}

extension BlogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        switch cell?.textLabel?.text {
        case "Followers":
            //TODO: Show followers for real, for now just show how many followers
            self.view.makeToast("\(blog.getFollowers().count) Follower(s)")
            break
        case "Follow":
            FollowBlogTask(callback: self, blogId: blog.getBlogId()).execute()
            break
        case "Unfollow":
            UnfollowBlogTask(callback: self, blogId: blog.getBlogId()).execute()
            break
        case "Report":
            //TODO: Handle report
            break
        case "Block":
            //TODO: Handle block
            break
        case "Unblock":
            //TODO: Handle unblock
            break
        default:
            //Unsupported action
            break
        }
        self.popover.dismiss()
    }
}

extension BlogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
        return cell
    }
}
