//
//  VideoPlayer.swift
//  StarTapped
//
//  Created by Nova Maday on 1/16/19.
//  Copyright © 2019 DreamExposure Studios. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

class VideoView: UIView {
    var controller: AVPlayerViewController?
    var player: AVPlayer?
    var isLoop: Bool = false
    var isAutoPlay: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(url: String) {
        if let videoURL = URL(string: url) {
            player = AVPlayer(url: videoURL)
            controller = AVPlayerViewController()
            
            controller?.player = player
            controller?.videoGravity = .resizeAspect
            controller?.view.frame = self.frame
            
            self.addSubview(controller!.view)
            
            NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
            
            if (isAutoPlay) {
                self.play()
            }
        }
    }

    func configure(url: URL) {
        player = AVPlayer(url: url)
        controller = AVPlayerViewController()

        controller?.player = player
        controller?.videoGravity = .resizeAspect
        controller?.view.frame = self.frame

        self.addSubview(controller!.view)

        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)

        if (isAutoPlay) {
            self.play()
        }
    }
    
    func play() {
        if player?.timeControlStatus != AVPlayer.TimeControlStatus.playing {
            player?.play()
        }
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player?.seek(to: CMTime.zero)
    }

    func kill() {
        if player != nil {
            self.stop()
        }

        player = nil
        controller = nil

        self.removeAllSubviews()
    }
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        if isLoop {
            player?.pause()
            player?.seek(to: CMTime.zero)
            player?.play()
        }
    }
}
