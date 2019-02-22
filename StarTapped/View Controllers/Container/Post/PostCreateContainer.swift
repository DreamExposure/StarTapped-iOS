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
    
    var controller: UIViewController!
    var postType: PostType = .TEXT
    
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
        
        self.removeAndHideImage()
        self.removeAndHideAudio()
        self.removeAndHideVideo()
    }
    
    //Post type changing and media handling
    func imageAdded() {
        postType = .IMAGE
        
        //TODO: Handle adding image
        
        postImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        postImage.isHidden = false
    }
    
    func audioAdded() {
        postType = .AUDIO
        
        //TODO: Handle adding audio
        
        audioContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        audioContainer.isHidden = false
    }
    
    func videoAdded() {
        postType = .VIDEO
        
        //TODO: Handle adding video
        
        videoContainer.heightAnchor.constraint(equalToConstant: 200).isActive = true
        videoContainer.isHidden = false
    }
    
    //Post media hiding
    func removeAndHideImage() {
        postImage.image = nil
        postImage.isHidden = true
        
        postImage.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        postType = .TEXT
    }
    
    func removeAndHideAudio() {
        audioView.stop()
        
        audioContainer.isHidden = true
        audioContainer.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        postType = .TEXT
    }
    
    func removeAndHideVideo() {
        videoView.stop()
        
        videoContainer.isHidden = true
        videoContainer.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        postType = .TEXT
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
        
        self.heightAnchor
            .constraint(equalToConstant: self.contentView.frame.height)
            .isActive = true
        self.widthAnchor
            .constraint(equalToConstant: self.contentView.frame.width)
            .isActive = true
        
        self.layoutIfNeeded()
    }
    
    //TODO: Make sure that this actually works.
    func textViewDidChange(_ textView: UITextView) {
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.sizeToFit()
        textView.isScrollEnabled = false
        
        let calHeight = textView.frame.size.height
        textView.frame.size.height = calHeight
    }
}
