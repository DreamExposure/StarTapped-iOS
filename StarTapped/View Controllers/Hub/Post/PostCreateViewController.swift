//
//  PostCreateViewController.swift
//  StarTapped
//
//  Created by Nova Maday on 2/22/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents
import Popover
import SwiftyJSON
import Toast_Swift

class PostCreateController: UIViewController, TaskCallback {
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var stackView: UIStackView!
    
    @IBOutlet weak var blogIcon: UIImageView!
    @IBOutlet weak var blogSelectButton: UIButton!
    
    var postContainer: PostCreateContainer!
    
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.auto),
        .blackOverlayColor(UIColor(red:0.12, green:0.15, blue:0.21, alpha:0.6))
    ]
    fileprivate var texts: [String] = []
    
    fileprivate var blogsToImages: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupVerticalScrollingStack()
        
        postContainer = PostCreateContainer()
        postContainer.fixTheStupid()
        stackView.addArrangedSubview(postContainer)
        
        GetBlogsSelfTask(callback: self).execute()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        //Go to previous view...
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func blogSelectButtonClicked(_ sender: UIButton) {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 2, height: CGFloat(42 * texts.count)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        self.popover = Popover(options: self.popoverOptions)
        self.popover.show(tableView, fromView: blogSelectButton)
    }
    
    @IBAction func onConfirmButtonClicked(_ sender: UIButton) {
        //TODO: Actually create the post!!!
    }
    
    @IBAction func onCameraButtonClick() {
        //TODO: Change type to image, handle showing image selector and stuff
    }
    
    @IBAction func onAudioButtonClick() {
        //TODO: Change type to audio, handle showing audio selector and stuff
    }
    
    @IBAction func onVideoButtonClick() {
        //TODO: Change type to video, handle showing video selector and stuff
    }
    
    @IBAction func onTagButtonClick() {
        //TODO: Handle showing tag editor and stuff
    }
    
    
    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .BLOG_GET_SELF_ALL:
            if (status.isSuccess()) {
                let jBlogs: [JSON] = status.getBody()["blogs"].arrayValue
                
                for jBlog in jBlogs {
                    let blog = Blog().fromJson(json: jBlog)
                    
                    self.blogsToImages[blog.getBaseUrl()] = blog.getIconImage().getUrl()
                    self.texts.append(blog.getBaseUrl())
                }
                //Set the default selected to the first one...
                DownloadImageTask(callback: self, url: blogsToImages[texts[0]]!, view: blogIcon).execute()
                blogSelectButton.setTitle(texts[0], for: .normal)
            }
            break
        case .POST_CREATE:
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
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: ["stackView": stackView]))
        
        //Center content horizontally
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
}

extension PostCreateController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        self.blogSelectButton.setTitle(cell?.textLabel?.text, for: .normal)
        DownloadImageTask(callback: self, url: blogsToImages[texts[indexPath.row]]!, view: blogIcon).execute()
        self.popover.dismiss()
    }
}

extension PostCreateController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return texts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = self.texts[(indexPath as NSIndexPath).row]
        return cell
    }
}
