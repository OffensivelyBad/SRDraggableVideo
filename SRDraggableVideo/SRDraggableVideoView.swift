//
//  SRDraggableVideoView.swift
//  SRDraggableVideo
//
//  Created by Shawn Roller on 6/24/19.
//  Copyright © 2019 Shawn Roller. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

public class SRDraggableVideoView: UIView {

    let nibName = "SRDraggableVideoView"
    var contentView: UIView!
    
    // Video properties
    var audioSession: AVAudioSession?
    var playerController: AVPlayerViewController?
    var player: AVPlayer?
    
}


// MARK: - public methods
extension SRDraggableVideoView {
    
    public override func layoutSubviews() {
        self.layoutIfNeeded()
    }
    
    public func set(backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
    }
    
    public func set(draggable: Bool) {
        if draggable {
            // Make the view draggable
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(SRDraggableVideoView.didDrag(_:)))
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(panGesture)
        }
    }
    
    public func playVideo() {
        self.player?.play()
    }
    
    public func configurePlayer(urlString: String) {
        // Setup video playback
        self.audioSession = AVAudioSession()
        do {
            try self.audioSession?.setCategory(.playback, mode: .moviePlayback)
        } catch {
            fatalError("Failed to initialize AV Session")
        }
        
        guard let url = URL(string: urlString) else { return }
        self.player = AVPlayer(url: url)
        self.playerController = AVPlayerViewController()
        self.playerController?.player = self.player
        self.playerController?.view.frame = self.bounds
        guard let playerView = self.playerController?.view else { return }
        self.addSubview(playerView)
        self.autoresizesSubviews = true
    }
    
}


// MARK: - private methods
extension SRDraggableVideoView {
    
    private func setupView() {
        
        // Layout the view
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: self.nibName, bundle: bundle)
        
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else { fatalError() }
        self.contentView = contentView
        self.addSubview(self.contentView)
        
        self.contentView.center = self.center
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    @objc private func didDrag(_ sender: UIPanGestureRecognizer) {
        guard let sView = self.superview else { return }
        let translation = sender.translation(in: sView)
        self.center = CGPoint(x: self.center.x + translation.x, y: self.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: sView)
    }
    
}
