//
//  PostCreateViewController.swift
//  StarTapped
//
//  Created by Nova Maday on 2/22/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer
import MaterialComponents
import Popover
import SwiftyJSON
import Toast_Swift

class PostCreateController: UIViewController, UIImagePickerControllerDelegate, MPMediaPickerControllerDelegate, UINavigationControllerDelegate, TaskCallback {
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
    fileprivate var blogNamesToBlogs: [String:Blog] = [:]
    fileprivate var selectedBlog: Int = 0

    fileprivate var currentPicker: String = "None"
    
    fileprivate var loadingAlert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupVerticalScrollingStack()
        
        postContainer = PostCreateContainer()
        postContainer.controller = self
        postContainer.fixTheStupid()
        stackView.addArrangedSubview(postContainer)
        
        GetBlogsSelfTask(callback: self).execute()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func onBackButtonClicked(_ sender: UIButton) {
        //Go to previous view...
        self.navigationController?.popViewController(animated: true)
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
        let blog = self.blogNamesToBlogs[texts[self.selectedBlog]]!
        let creator = Settings().getAccount()

        let post = Post(creator: creator, originBlog: blog)

        post.setType(type: self.postContainer.postType)
        post.setTitle(title: self.postContainer.postTitle.text)
        post.setBody(body: self.postContainer.postBody.text)
        post.tagsFromString(tagString: self.postContainer.postTags.text)

        //This is handled on the backend, will add support to allow user's to change this later
        post.setNsfw(nsfw: false)
        
        let task: PostCreateTask
        if (post.getType() == .IMAGE || post.getType() == .AUDIO || post.getType() == .VIDEO) {
            task = PostCreateTask(callback: self, post: post, media: self.postContainer.postMediaJson)
        } else {
            task = PostCreateTask(callback: self, post: post)
        }
        
        //Show loading alert...
        loadingAlert = UIAlertController(title: "Creating Post", message: "Please wait while we create your post...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        loadingAlert.view.addSubview(loadingIndicator)
        self.present(loadingAlert, animated: true, completion: nil)
        
        task.execute()
    }
    
    @IBAction func onCameraButtonClick() {
        //Create popup for media selection location thingy because iOS is dumb.
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.openImagePicker(sourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.openImagePicker(sourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onAudioButtonClick() {
        self.postContainer.removeAndHideImage()
        self.postContainer.removeAndHideAudio()
        self.postContainer.removeAndHideVideo()

        self.currentPicker = "Audio"

        let picker = MPMediaPickerController(mediaTypes: .anyAudio)
        picker.delegate = self
        picker.showsCloudItems = false
        picker.allowsPickingMultipleItems = false
        picker.showsItemsWithProtectedAssets = false
        self.present(picker, animated: true, completion: nil)
    }

    @IBAction func onVideoButtonClick() {
        /*
        self.postContainer.removeAndHideImage()
        self.postContainer.removeAndHideAudio()
        self.postContainer.removeAndHideVideo()

        self.currentPicker = "Video"

        let picker = MPMediaPickerController(mediaTypes: .anyVideo)
        picker.delegate = self
        picker.showsCloudItems = false
        picker.allowsPickingMultipleItems = false
        picker.showsItemsWithProtectedAssets = false
        self.present(picker, animated: true, completion: nil)
         */
        
        let alert = UIAlertController(title: "Unsupported on iOS", message: "Due to the Media Picker not allowing video, video posts cannot be created on iOS. Sorry.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func onCallBack(status: NetworkCallStatus) {
        switch status.getType() {
        case .BLOG_GET_SELF_ALL:
            if (status.isSuccess()) {
                let jBlogs: [JSON] = status.getBody()["blogs"].arrayValue
                
                for jBlog in jBlogs {
                    let blog = Blog().fromJson(json: jBlog)
                    
                    self.blogNamesToBlogs[blog.getBaseUrl()] = blog
                    self.texts.append(blog.getBaseUrl())
                }
                //Set the default selected to the first one...
                DownloadImageTask(callback: self, url: (self.blogNamesToBlogs[texts[0]]?.getIconImage().getUrl())!, view: blogIcon).execute()
                blogSelectButton.setTitle(texts[0], for: .normal)
            }
            break
        case .POST_CREATE:
            self.loadingAlert.dismiss(animated: true, completion: nil)
            if status.isSuccess() {
                //self.view.makeToast("Success!")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.view.makeToast("Error: \(status.getMessage())")
            }
            break
        default:
            break
        }
    }
    
    func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        self.postContainer.removeAndHideImage()
        self.postContainer.removeAndHideAudio()
        self.postContainer.removeAndHideVideo()

        if sourceType == .camera {
            self.currentPicker = "Camera"
        } else if sourceType == .photoLibrary {
            self.currentPicker = "Gallery"
        }

        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = false
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if self.currentPicker == "Camera" {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            postContainer.imageAdded(image: image!)
        } else if self.currentPicker == "Gallery" {
            let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL
            postContainer.imageAdded(imageUrl: imageUrl!)
        }
        picker.dismiss(animated: true, completion: nil)
        self.currentPicker = "None"
    }

    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        if mediaItemCollection.count > 0 {
            let itemUrl: URL = mediaItemCollection.items[0].assetURL!
            if self.currentPicker == "Audio" {
                self.postContainer.audioAdded(audioUrl: itemUrl)
            } else if self.currentPicker == "Video" {
                self.postContainer.videoAdded(videoUrl: itemUrl)
            }
        }

        mediaPicker.dismiss(animated: true, completion: nil)
        self.currentPicker = "None"
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.currentPicker = "None"
    }

    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
        self.currentPicker = "None"
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

        self.selectedBlog = indexPath.row
        self.blogSelectButton.setTitle(cell?.textLabel?.text, for: .normal)
        DownloadImageTask(callback: self, url: (self.blogNamesToBlogs[texts[indexPath.row]]?.getIconImage().getUrl())!, view: blogIcon).execute()
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
