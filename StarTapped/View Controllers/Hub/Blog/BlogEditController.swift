//
// Created by Nova Maday on 2019-02-26.
// Copyright (c) 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import MaterialComponents
import SwiftyJSON
import Toast_Swift

class BlogEditController: UIViewController, TaskCallback {
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var toolbarTitle: UIBarButtonItem!

    @IBOutlet weak var scrollView: UIScrollView!
    var stackView: UIStackView!

    var blogContainer: BlogEditContainer!

    var blogId: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupVerticalScrollingStack()

        blogContainer = BlogEditContainer()
        blogContainer.controller = self
        blogContainer.toolbarTitle = self.toolbarTitle
        blogContainer.fixTheStupid()
        stackView.addArrangedSubview(blogContainer)

        GetBlogViewTask(callback: self, blogId: self.blogId).execute()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        //Go to previous view...
        self.navigationController?.popViewController(animated: true)
    }


    @IBAction func onConfirmButtonClicked(_ sender: UIButton) {
        let blog = Blog()
        //Set stuff that doesn't change....
        blog.setBlogId(blogId: self.blogId)
        blog.setBlogType(type: self.blogContainer.blog.getBlogType())

        //All the stuff that can be edited...
        blog.setName(name: self.blogContainer.blogName.text)
        blog.setDescription(desc: self.blogContainer.blogDescription.text)
        blog.setNsfw(nsfw: self.blogContainer.isNsfwSwitch.isOn)
        blog.setAllowUnder18(allow: self.blogContainer.allowMinorsSwitch.isOn)

        if blog.getBlogType() == .PERSONAL {
            blog.setDisplayAge(display: self.blogContainer.displayAgeSwitch.isOn)
        }

        let task = UpdateBlogTask(callback: self, blog: blog, icon: self.blogContainer.iconImageFile, background: self.blogContainer.backgroundImageFile)

        task.execute()
    }

    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .BLOG_GET_VIEW:
            if (status.isSuccess()) {
                let blog = Blog().fromJson(json: status.getBody()["blog"])

                self.blogContainer.configureWithBlog(blog: blog)
            } else {
                self.view.makeToast(status.getMessage())
            }
            break
        case .BLOG_UPDATE_SELF:
            if status.isSuccess() {
                self.view.makeToast("Success!")
                self.dismiss(animated: true, completion: nil)
            } else {
                self.view.makeToast(status.getMessage())
            }
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

        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView!]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView!]))

        //Center content horizontally
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}
