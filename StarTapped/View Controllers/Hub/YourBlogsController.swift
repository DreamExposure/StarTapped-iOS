//
//  YourBlogsController.swift
//  StarTapped
//
//  Created by Nova Maday on 1/11/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift
import SwiftyJSON

class YourBlogsController: UIViewController, TaskCallback {
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupVerticalScrollingStack()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let getBlogsTask = GetBlogsSelfTask(callback: self)
        getBlogsTask.execute()
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onNewBlockButtonClicked(_ sender: UIButton) {
        //TODO: Open view to create new blog
    }
    
    func displayBlogs(status: NetworkCallStatus) {
        let jBlogs: [JSON] = status.getBody()["blogs"].arrayValue
        
        for jBlog in jBlogs {
            let blog = Blog().fromJson(json: jBlog)
            let blogCon: BlogForSelfListConainer = BlogForSelfListConainer()
            blogCon.controller = self
            
            blogCon.configure(blog: blog, jBlog: jBlog)
            
            blogCon.fixTheStupid()
            
            self.stackView.addArrangedSubview(blogCon)
        }
    }
    
    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .BLOG_GET_SELF_ALL:
            if (status.isSuccess()) {
                self.displayBlogs(status: status)
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
}
