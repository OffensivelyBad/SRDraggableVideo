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

public protocol DraggableVideoDelegate {
    func stopTapped()
}

public class SRDraggableVideoViewController: UIViewController {
        
    // Video properties
    var audioSession: AVAudioSession?
    var playerController: AVPlayerViewController?
    var player: AVPlayer?
    
    // delegation
    public var delegate: DraggableVideoDelegate?
    
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
        
        guard let url = URL(string: urlString) else {
            debugPrint("video \(urlString) not found")
            return
        }
        self.player = AVPlayer(url: url)
        self.playerController = AVPlayerViewController()
        self.playerController?.player = self.player
        self.playerController?.view.frame = self.view.bounds
        
        guard let controller = self.playerController else { return }
        self.addChild(controller)
        
        guard let playerView = controller.view else { return }
        self.view.addSubview(playerView)
        self.view.autoresizesSubviews = true
        
        // Add a stop button
        let button = self.getStopButton()
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
    }
    
    public func configurePlayer(filePath: String) {
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
        
        let url = URL(fileURLWithPath: filePath)
        self.player = AVPlayer(url: url)
        self.playerController = AVPlayerViewController()
        self.playerController?.player = self.player
        self.playerController?.view.frame = self.view.bounds
        
        guard let controller = self.playerController else { return }
        self.addChild(controller)
        
        guard let playerView = controller.view else { return }
        self.view.addSubview(playerView)
        self.view.autoresizesSubviews = true
        
        // Add a stop button
        let button = self.getStopButton()
        self.view.addSubview(button)
        self.view.bringSubviewToFront(button)
    }
    
}


// MARK: - private methods
extension SRDraggableVideoViewController {
    
    private func setupView() {
        self.view.translatesAutoresizingMaskIntoConstraints = true
    }
    
    internal func getStopButton() -> UIButton {
        // Add a stop button to the bottom right of the view
        let width = self.view.frame.width
        let height = self.view.frame.height
        let buttonSize = CGSize(width: 30, height: 30)
        let rect = CGRect(x: width - buttonSize.width, y: height - buttonSize.height, width: buttonSize.width, height: buttonSize.height)
        
        let stopButton = UIButton(frame: rect)
        stopButton.addTarget(self, action: #selector(stopTapped(_:)), for: .touchUpInside)
        
        let xShape = self.drawX()
        stopButton.layer.addSublayer(xShape)
        
        return stopButton
    }
    
    @objc internal func didDrag(_ sender: UIPanGestureRecognizer) {
        guard let sView = self.view.superview else { return }
        let translation = sender.translation(in: sView)
        self.view.center = CGPoint(x: self.view.center.x + translation.x, y: self.view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: sView)
    }
    
    @objc internal func stopTapped(_ sender: AnyObject?) {
        self.delegate?.stopTapped()
    }
    
    private func drawX() -> CAShapeLayer {
        
        let shapeLayer = CAShapeLayer()
        let bezierPaths = UIBezierPath()
        
        //// Line Drawing
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 8.5, y: 8.5))
        linePath.addLine(to: CGPoint(x: 26.5, y: 26.5))
        
        bezierPaths.append(linePath)
        
        let line1Path = UIBezierPath()
        line1Path.move(to: CGPoint(x: 26.5, y: 8.5))
        line1Path.addLine(to: CGPoint(x: 8.5, y:26.5))
        
        bezierPaths.append(line1Path)
        
        shapeLayer.path = bezierPaths.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 2
        return shapeLayer
        
    }
    
}


