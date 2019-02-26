//
//  PostCreateContainer.swift
//  StarTapped
//
//  Created by Nova Maday on 2/21/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import FRHyperLabel
import UITextView_Placeholder
import PopupDialog
import SwiftyJSON

class PostCreateContainer: UIView, UITextViewDelegate {
    @IBOutlet weak var contentView: UIView!
    
    //Image contents
    @IBOutlet weak var postImage: UIImageView!
    
    //Audio contents
    @IBOutlet weak var audioContainer: UIView!
    @IBOutlet weak var audioView: AudioView!
    
    //Video contents
    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var videoView: VideoView!
    
    //Text
    @IBOutlet weak var postTitle: UITextView!
    @IBOutlet weak var postBody: UITextView!
    @IBOutlet weak var postTags: UITextView!

    //Constraints
    var contentHeight: NSLayoutConstraint!
    var imageHeightShow: NSLayoutConstraint!
    var imageHeightHidden: NSLayoutConstraint!
    var audioHeightShow: NSLayoutConstraint!
    var audioHeightHidden: NSLayoutConstraint!
    var videoHeightShow: NSLayoutConstraint!
    var videoHeightHidden: NSLayoutConstraint!
    var postTitleHeight: NSLayoutConstraint!
    var postBodyHeight: NSLayoutConstraint!
    var postTagsHeight: NSLayoutConstraint!
    
    //Other stuffs
    var controller: UIViewController!

    //Post stuffs
    var postType: PostType = .TEXT
    var postMediaJson: [String: String]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("PostCreateContainer", owner: self  , options: nil)
        self.addSubview(self.contentView)

        self.contentHeight = self.heightAnchor.constraint(equalToConstant: 800)
        self.contentHeight.isActive = true
        
        self.postTitle.delegate = self
        self.postBody.delegate = self
        self.postTags.delegate = self
        self.postTitleHeight = self.postTitle.heightAnchor.constraint(equalToConstant: self.postTitle.frame.height)
        self.postBodyHeight = self.postBody.heightAnchor.constraint(equalToConstant: self.postBody.frame.height)
        self.postTagsHeight = self.postTags.heightAnchor.constraint(equalToConstant: self.postTags.frame.height)
        self.postTitleHeight.isActive = true
        self.postBodyHeight.isActive = true
        self.postTagsHeight.isActive = true

        imageHeightShow = postImage.heightAnchor.constraint(equalToConstant: 200)
        imageHeightHidden = postImage.heightAnchor.constraint(equalToConstant: 0)
        imageHeightShow.isActive = false
        imageHeightHidden.isActive = true
        
        audioHeightShow = audioContainer.heightAnchor.constraint(equalToConstant: 200)
        audioHeightHidden = audioContainer.heightAnchor.constraint(equalToConstant: 0)
        audioHeightShow.isActive = false
        audioHeightHidden.isActive = true
        
        videoHeightShow = videoContainer.heightAnchor.constraint(equalToConstant: 200)
        videoHeightHidden = videoContainer.heightAnchor.constraint(equalToConstant: 0)
        videoHeightShow.isActive = false
        videoHeightHidden.isActive = true

        self.removeAndHideImage()
        self.removeAndHideAudio()
        self.removeAndHideVideo()
    }
    
    //Post type changing and media handling
    func imageAdded(imageUrl: URL) {
        postType = .IMAGE

        self.postMediaJson = FileUtils().fileToBase64(filePath: imageUrl.path)
        
        postImage.sd_setImage(with: imageUrl)
        
        imageHeightHidden.isActive = false
        imageHeightShow.isActive = true
        
        postImage.isHidden = false
        self.fixTheStupid()
    }

    func imageAdded(image: UIImage) {
        postType = .IMAGE

        self.postMediaJson = FileUtils().imageToBase64(image: image)

        postImage.image = image

        imageHeightHidden.isActive = false
        imageHeightShow.isActive = true

        postImage.isHidden = false
        self.fixTheStupid()
    }
    
    func audioAdded(audioUrl: URL) {
        postType = .AUDIO

        self.postMediaJson = FileUtils().fileToBase64(filePath: audioUrl.path)

        audioView.configure(url: audioUrl)

        audioHeightHidden.isActive = false
        audioHeightShow.isActive = true

        audioContainer.isHidden = false
        self.fixTheStupid()
    }
    
    func videoAdded(videoUrl: URL) {
        postType = .VIDEO

        self.postMediaJson = FileUtils().fileToBase64(filePath: videoUrl.path)

        videoView.configure(url: videoUrl)

        videoHeightHidden.isActive = false
        videoHeightShow.isActive = true

        videoContainer.isHidden = false
        self.fixTheStupid()
    }
    
    //Post media hiding
    func removeAndHideImage() {
        postImage.image = nil
        postImage.isHidden = true

        imageHeightShow.isActive = false
        imageHeightHidden.isActive = true
    
        
        postType = .TEXT
        self.postMediaJson = nil
        self.fixTheStupid()
    }
    
    func removeAndHideAudio() {
        audioView.kill()
        
        audioContainer.isHidden = true

        audioHeightShow.isActive = false
        audioHeightHidden.isActive = true
        
        postType = .TEXT
        self.postMediaJson = nil
        self.fixTheStupid()
    }
    
    func removeAndHideVideo() {
        videoView.kill()
        
        videoContainer.isHidden = true

        videoHeightShow.isActive = false
        videoHeightHidden.isActive = true
        
        postType = .TEXT
        self.postMediaJson = nil
        self.fixTheStupid()
    }
    
    
    @IBAction func imageClicked() {
        let popup = PopupDialog(title: nil, message: nil, image: postImage.image)
        
        let close = CancelButton(title: "Close") {}
        
        popup.addButtons([close])
        
        popup.transitionStyle = .zoomIn
        
        self.controller.present(popup, animated: true, completion: nil)
    }

    func fixTheStupid() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.layoutIfNeeded()
        
        self.contentHeight.constant = self.contentView.frame.height
        self.widthAnchor
            .constraint(equalToConstant: self.contentView.frame.width)
            .isActive = true
        
        self.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = false

        let newSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat(MAXFLOAT)))

        textView.frame.size.height = newSize.height
        textView.setNeedsDisplay()
        textView.setNeedsUpdateConstraints()
        
        if textView == postTitle {
            postTitleHeight.constant = newSize.height
        } else if textView == postBody {
            postBodyHeight.constant = newSize.height
        } else {
            postTagsHeight.constant = newSize.height
        }
        
        textView.isScrollEnabled = false
        
        self.fixTheStupid()
    }
}
