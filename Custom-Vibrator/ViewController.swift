//
//  ViewController.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 2/7/25.
//

import UIKit
import CoreHaptics
import SwiftUI

class ViewController: UIViewController {
    
    var hapticEngine: CHHapticEngine?
    var hapticPlayer: CHHapticAdvancedPatternPlayer?
    
    let totalDuration: TimeInterval = 10.0
    var timelineStartTime: TimeInterval?
    var touchStartTime: TimeInterval?
    var displayLink: CADisplayLink?
    
    
    var recordedSegments: [(start: TimeInterval, end: TimeInterval)] = []
    
    private var isResetTapped: Bool = true
    private var longTouchTimer: Timer?
    
    
    //MARK: UI
    private lazy var touchArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .surfaceBg
        return view
    }()
    
    private lazy var bottomArea: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.bg
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var touchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timelineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.textPrimary
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var playHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: timelineView.bounds.height))
        view.backgroundColor = UIColor.progress
        view.layer.cornerRadius = 4
        return view
    }()
    
    
    private lazy var resetButton: UIButton = {
        
        var attributedString = AttributedString("Reset")
        attributedString.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attributedString
        config.image = UIImage(systemName: "stop.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.background.cornerRadius = 24
        config.baseBackgroundColor = UIColor.white
        config.baseForegroundColor = UIColor.textPrimary
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var playButton: UIButton = {
        
        var attributedString = AttributedString("Play")
        attributedString.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attributedString
        config.image = UIImage(systemName: "play.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        config.imagePlacement = .leading
        config.imagePadding = 4
        config.background.cornerRadius = 24
        config.baseBackgroundColor = UIColor.white
        config.baseForegroundColor = UIColor(red: 0.27, green: 0.12, blue: 0.36, alpha: 1)
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        button.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    //MARK: - SetupUI
    private func setupUI() {
        view.addSubview(touchArea)
        view.addSubview(bottomArea)
        view.addSubview(touchLabel)
        view.addSubview(playButton)
        view.addSubview(timelineView)
        view.addSubview(resetButton)
        
        NSLayoutConstraint.activate([
            touchArea.topAnchor.constraint(equalTo: self.view.topAnchor),
            touchArea.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            touchArea.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            touchArea.bottomAnchor.constraint(equalTo: bottomArea.topAnchor, constant: 0),
            
            bottomArea.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            bottomArea.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            bottomArea.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            bottomArea.heightAnchor.constraint(equalToConstant: self.view.bounds.height * (170/896)),
            
            timelineView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timelineView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            timelineView.topAnchor.constraint(equalTo: bottomArea.topAnchor, constant: 16),
            timelineView.heightAnchor.constraint(equalToConstant: 20),

            resetButton.leadingAnchor.constraint(equalTo: timelineView.leadingAnchor),
            resetButton.topAnchor.constraint(equalTo: timelineView.bottomAnchor, constant: 24),
                        
            playButton.trailingAnchor.constraint(equalTo: timelineView.trailingAnchor),
            playButton.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor),
            
            touchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touchLabel.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor),
        ])
    }
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        let uiHostingController = UIHostingController(rootView: NoVibratorView())

        navigationController?.pushViewController(uiHostingController, animated: true)
//        view.backgroundColor = .bg
//        setupUI()
//        prepareHaptics()
    }
    
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("could not access haptic")
        }
    }
    
    private func startHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        
        let event = CHHapticEvent(
            eventType: .hapticContinuous,
            parameters: [intensity, sharpness],
            relativeTime: 0,
            duration: 10)
        
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            hapticPlayer = try hapticEngine?.makeAdvancedPlayer(with: pattern)
            try hapticPlayer?.start(atTime: 0)
        } catch {
            print("could not start haptic engine!")
        }
    }
    
    private func stopHaptic() {
        try? hapticPlayer?.stop(atTime: 0)
    }
    
    
    private func startTimeLine() {
        playButton.isEnabled = false
        timelineStartTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(updatePlayhead))
        displayLink?.add(to: .main, forMode: .default)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            self.displayLink?.invalidate()
            self.playButton.isEnabled = true
        }
    }
    
    @objc
    func updatePlayhead() {
        guard let start = timelineStartTime else { return }
        let elapsedTime = CACurrentMediaTime() - start
        let progress = min(1, (elapsedTime / totalDuration))
        
        let barWidth = timelineView.bounds.width
        let currentWidth = progress * barWidth
        
        playHeaderView.frame = CGRect(x: 0, y: 0, width: currentWidth, height: timelineView.bounds.height)
    }
    
    @objc
    private func resetTapped() {
        print("reset tapped")
        
        timelineView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        isResetTapped = true
        
        displayLink?.invalidate()
        displayLink =  nil
        playHeaderView.frame.origin.x = 0
        recordedSegments = []
    }
    
    @objc
    private func playTapped() {
        print("play tapped")
        
        guard playButton.isEnabled else { return }
        
        playButton.isEnabled = false
        playHapticPattern(recordedSegments)
        
        playHeaderView.frame = CGRect(x: 0, y: 0, width: 0, height: timelineView.bounds.height)
        
        UIView.animate(withDuration: totalDuration, delay: 0, options: [.curveLinear]) {
            self.playHeaderView.frame = CGRect(x: 0, y: 0, width: self.timelineView.bounds.width, height: self.timelineView.bounds.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            self.playButton.isEnabled = true
        }
    }
    
    private func playHapticPattern(_ segments: [(start: TimeInterval, end: TimeInterval)]) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            try hapticEngine?.start()
            
            try hapticPlayer?.stop(atTime: 0)
            
            print("haptic running")
            
            let events: [CHHapticEvent] = segments.map { segment in
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
                
                return CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: segment.start, duration: segment.end - segment.start)
            }
                
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("error to replay for \(error)")
        }
    }
    
    
    //MARK: - Animation
    private func addTouchReflection(from: TimeInterval, to: TimeInterval) {
        let barWidth = timelineView.bounds.width
        let startX = CGFloat(from / totalDuration) * barWidth
        let width = CGFloat((to - from) / totalDuration) * barWidth
        
        let segment = UIView(frame: CGRect(x: startX, y: timelineView.bounds.height / 4, width: max(width, 1.5), height: timelineView.bounds.height / 2))
        segment.backgroundColor = UIColor.segment
        segment.layer.cornerRadius = 2
        timelineView.addSubview(segment)
    }
    
    func showLongTouchRipple(at point: CGPoint) {
        createRippleRing(at: point)
    }
    
    
    func createRippleRing(at point: CGPoint) {
        let diameter: CGFloat = 80
        let ring = UIView(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        ring.center = point
        ring.layer.cornerRadius = diameter / 2
        ring.layer.borderColor = UIColor.white.cgColor
        ring.layer.borderWidth = 1
        ring.alpha = 0.2
        ring.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseOut, .repeat]) {
            ring.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            ring.alpha = 0.0
        } completion: { _ in
            ring.removeFromSuperview()
        }
    }
    
    
    private func clearAllRipples() {
        self.view.subviews.forEach { subView in
            if subView.tag == 999 {
                subView.removeFromSuperview()
            }
        }
    }
    
    func showRippleForMovement(at point: CGPoint) {
        let rippleSize: CGFloat = 60
        let ripple = UIView(frame: CGRect(x: 0, y: 0, width: rippleSize, height: rippleSize))
        ripple.center = point
        ripple.layer.cornerRadius = rippleSize / 2
        ripple.layer.borderWidth = 1.5
        ripple.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        ripple.backgroundColor = UIColor.clear
        view.addSubview(ripple)
        
        UIView.animate(withDuration: 0.5, animations: {
            ripple.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            ripple.alpha = 0.0
        }, completion: { _ in
            ripple.removeFromSuperview()
        })
    }
    
    
    private func highlightTouchArea(at point: CGPoint) {
        let circleSize: CGFloat = 65
        
        let rippleContainer = UIView(frame: CGRect(x: 0, y: 0, width: circleSize, height: circleSize))
        rippleContainer.center = point
        rippleContainer.tag = 888
        self.view.addSubview(rippleContainer)
        
        for i in 0..<4 {
            let ripple = UIView(frame: rippleContainer.bounds)
            ripple.layer.cornerRadius = circleSize / 2
            ripple.layer.borderColor = UIColor.whitesecondary.cgColor
            ripple.layer.borderWidth = 2
            ripple.alpha = 0.0
            rippleContainer.addSubview(ripple)
            
            let delay = CFTimeInterval(i) * 0.15
            
            let animationGroup = CAAnimationGroup()
            animationGroup.beginTime = CACurrentMediaTime() + delay
            animationGroup.duration = 0.2
            animationGroup.repeatCount = .infinity
            animationGroup.autoreverses = false
            animationGroup.isRemovedOnCompletion = false
            
            let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
            scaleAnim.fromValue = 1.0
            scaleAnim.toValue = 2.5
            
            let alphaAnim = CABasicAnimation(keyPath: "opacity")
            alphaAnim.fromValue = 0.6
            alphaAnim.toValue = 0.0
            
            animationGroup.animations = [scaleAnim, alphaAnim]
            ripple.layer.add(animationGroup, forKey: "ripple")
        }
    }
}

//MARK: - Touch
extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isResetTapped {
            timelineView.addSubview(playHeaderView)
            startTimeLine()
            isResetTapped = false
        }
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        
        if touchArea.frame.contains(location) {
            
            guard timelineStartTime != nil else { return }
            touchStartTime = CACurrentMediaTime()
            startHaptic()
            
            highlightTouchArea(at: location)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchLabel.text = "Touch Ended"
        guard let touchStart = touchStartTime, let globalStart = timelineStartTime else { return }
        
        let touchEnded = CACurrentMediaTime()
        let relativeStart = max(0, touchStart - globalStart)
        let relativeEnd = max(0, touchEnded - globalStart)
        
        recordedSegments.append((start: relativeStart, end: relativeEnd))
        
        UIView.animate(withDuration: 0.3) {
            self.addTouchReflection(from: relativeStart, to: relativeEnd)
        }
        stopHaptic()
        longTouchTimer?.invalidate()
        longTouchTimer = nil
        touchStartTime = nil
        self.view.subviews.forEach { subview in
            if subview.tag == 999 || subview.tag == 888 {
                subview.removeFromSuperview()
            }
        }
        clearAllRipples()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocation = touches.first?.location(in: view) else { return }
        
        self.view.subviews.forEach { subview in
            if subview.tag == 888 {
                subview.removeFromSuperview()
            }
        }
        showRippleForMovement(at: touchLocation)
    }
}
