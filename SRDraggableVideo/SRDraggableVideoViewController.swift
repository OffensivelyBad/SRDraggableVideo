//
//  SRDraggableVideoViewController.swift
//  SRDraggableVideo
//
//  Created by Shawn Roller on 6/24/19.
//  Copyright © 2019 Shawn Roller. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

public class SRDraggableVideoViewController: UIViewController {
        
    // Video properties
    var audioSession: AVAudioSession?
    var playerController: AVPlayerViewController?
    var player: AVPlayer?
    
}
    
    
// MARK: - public methods
extension SRDraggableVideoViewController {
    
    public func set(backgroundColor: UIColor) {
        self.view.backgroundColor = backgroundColor
    }
    
    public func set(draggable: Bool) {
        if draggable {
            // Make the view draggable
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SRDraggableVideoViewController.didDrag(_:)))
            self.view.isUserInteractionEnabled = true
            self.view.addGestureRecognizer(panGesture)
        }
    }
    
    public func playVideo() {
        self.player?.play()
    }
    
    public func configurePlayer(urlString: String) {
        // Setup video playback
        self.audioSession = AVAudioSession()
        do {
            if #available(iOS 10.0, *) {
                try self.audioSession?.setCategory(.playback, mode: .moviePlayback)
            } else {
                // Fallback on earlier versions
            }
        } catch {
            fatalError("Failed to initialize AV Session")
        }
        
        guard let url = URL(string: urlString) else { return }
        self.player = AVPlayer(url: url)
        self.playerController = AVPlayerViewController()
        self.playerController?.player = self.player
        self.playerController?.view.frame = self.view.bounds
        
        guard let controller = self.playerController else { return }
        self.addChild(controller)
        
        guard let playerView = controller.view else { return }
        self.view.addSubview(playerView)
        self.view.autoresizesSubviews = true
    }
    
}


// MARK: - private methods
extension SRDraggableVideoViewController {
    
    private func setupView() {
        self.view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    @objc internal func didDrag(_ sender: UIPanGestureRecognizer) {
        guard let sView = self.view.superview else { return }
        let translation = sender.translation(in: sView)
        self.view.center = CGPoint(x: self.view.center.x + translation.x, y: self.view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: sView)
    }
    
}


