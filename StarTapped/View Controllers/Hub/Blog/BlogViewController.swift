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

class BlogViewController: UIViewController, TaskCallback {
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarTitle:  UIBarButtonItem!
    
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var stackView: UIStackView!
    
    var previousView: ViewType!
    var blogId: String!
    
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.auto),
        .blackOverlayColor(UIColor(red:0.12, green:0.15, blue:0.21, alpha:0.6))
    ]
    fileprivate var texts = ["Followers", "Follow", "Unfollow", "Report", "Block", "Unblock"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupVerticalScrollingStack()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Get blog
        GetBlogViewTask(callback: self, blogId: self.blogId).execute()
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        //Go to previous view...
        ViewUtils().goTo(view: self, anim: true, viewType: self.previousView)
    }
    
    func displayBlog(status: NetworkCallStatus) {
        let blog = Blog().fromJson(json: status.getBody()["blog"])
        toolbarTitle.title = blog.getBaseUrl()
        
        let blogCon: BlogViewContainer = BlogViewContainer()
            
        blogCon.configure(blog: blog, jBlog: status.getBody()["blog"])
            
        blogCon.fixTheStupid()
            
        self.stackView.addArrangedSubview(blogCon)
        
        //TODO: Determine hide/show followers, follow, unfollow, report, block, unblock
    }
    
    //TODO: Add support for loading in posts!!
    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .BLOG_GET_VIEW:
            if (status.isSuccess()) {
                self.displayBlog(status: status)
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
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        //Center content horizontally
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        //TODO: Copy blog URL to clipboard...
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
        switch indexPath.row {
        //TODO: Handle more button item clicks!!!!!!
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
