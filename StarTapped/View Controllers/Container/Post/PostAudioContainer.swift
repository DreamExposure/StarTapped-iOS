//
//  PostAudioContainer.swift
//  StarTapped
//
//  Created by Nova Maday on 1/16/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class PostAudioContainer: PostContainerBase, TaskCallback {
    //TODO: figure out how to handle media
    //TODO: Figure out how to handle the slider change
    //TODO: figure out how to sync media to slider
    //TODO: Figure out how to mute/unmute media
    //TODO: Figure out how to play/pause media
    //TODO: Figure out how to get media file name
    
    //Audio stuffs
    @IBOutlet weak var audioContainer: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var muteUnmuteButton: UIButton!
    @IBOutlet weak var audioFileName: UILabel!
    @IBOutlet weak var audioSeekbar: UISlider!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        Bundle.main.loadNibNamed("PostAudioContainer", owner: self  , options: nil)
        self.addSubview(self.contentView)
    }
    
    func configure(post: Post, controller: UIViewController) {
        self.post = post
        self.parent = nil
        self.controller = controller
        
        //top bar
        blogUrlLatest.setTitle(post.getOriginBlog().getBaseUrl(), for: .normal)
        reblogIcon.isHidden = true
        blogUrlSecond.isHidden = true
        
        //Post contents
        postTitle.text = post.getTitle()
        postText.text = post.getBody()
        
        //TODO: Load audio
        
        //Bottom bar
        sourceBlog.setTitle("Source \(post.getOriginBlog().getBaseUrl())", for: .normal)

        super.configureUrlButtons()
    }
    
    func configure(post: Post, parent: Post, controller: UIViewController) {
        self.post = post
        self.parent = parent
        self.controller = controller
        
        //Top bar
        blogUrlLatest.setTitle(post.getOriginBlog().getBaseUrl(), for: .normal)
        reblogIcon.isHidden = false
        blogUrlSecond.setTitle(parent.getOriginBlog().getBaseUrl(), for: .normal)
        blogUrlSecond.isHidden = false
        
        //Post contents
        postTitle.text = post.getTitle()
        postText.text = post.getBody()
        
        //TODO: Load audio
        
        //Bottom bar
        sourceBlog.setTitle("Source: \(post.getOriginBlog().getBaseUrl())", for: .normal)

        super.configureUrlButtons()
    }
    
    override func fixTheStupid() {
        //TODO: Resize audio container stuffs

        super.fixTheStupid();
    }
    
    @IBAction func onPlayPauseButtonClick() {
        //TODO: Handle play/pause click.
    }
    
    @IBAction func onMuteUnmuteButtonClick() {
        //TODO: Handle mute/unmute click.
    }
    
    func onCallBack(status: NetworkCallStatus) {
        //Can safely ignore, its just for downloading images.
    }
}
