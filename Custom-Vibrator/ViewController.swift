//
//  ViewController.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 2/7/25.
//

import UIKit
import CoreHaptics

class ViewController: UIViewController {
    
    var hapticEngine: CHHapticEngine?
    var hapticPlayer: CHHapticAdvancedPatternPlayer?
    
    let totalDuration: TimeInterval = 10.0
    var timelineStartTime: TimeInterval?
    var touchStartTime: TimeInterval?
    var displayLink: CADisplayLink?
    
    
    private lazy var touchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var timelineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.timelineBar
        view.layer.cornerRadius = 4
        return view
    }()
    
    private lazy var playHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 20))
        view.backgroundColor = .red
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
        config.baseForegroundColor = .purple
        config.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16)
        
        let button = UIButton(configuration: config, primaryAction: nil)
        
        button.addTarget(self, action: #selector(resetTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("hellow")
        view.backgroundColor = .bg
        setupUI()
        prepareHaptics()
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
    
    //MARK: - SetupUI
    private func setupUI() {
        view.addSubview(resetButton)
        view.addSubview(touchLabel)
        view.addSubview(timelineView)
        
        NSLayoutConstraint.activate([
            resetButton.leadingAnchor.constraint(equalTo: timelineView.leadingAnchor),
            resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),

            touchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touchLabel.centerYAnchor.constraint(equalTo: resetButton.centerYAnchor),
            
            timelineView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timelineView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            timelineView.bottomAnchor.constraint(equalTo: resetButton.topAnchor, constant: -10),
            timelineView.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        timelineView.addSubview(playHeaderView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startTimeLine()
        }
    }
    
    private func startTimeLine() {
        timelineStartTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(updatePlayhead))
        displayLink?.add(to: .main, forMode: .default)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            self.displayLink?.invalidate()
           // self.playHeaderView.removeFromSuperview()
        }
    }

    @objc
    func updatePlayhead() {
        guard let start = timelineStartTime else { return }
        let elapsedTime = CACurrentMediaTime() - start
        let progress = min(1, (elapsedTime / totalDuration))
        
        let barWidth = timelineView.bounds.width
        let x = progress * barWidth
        playHeaderView.frame.origin.x = x
    }
    
    @objc
    private func resetTapped() {
        print("reset tapped")
        
        timelineView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        startTimeLine()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("**touchesBegan")
        touchLabel.text = "Haptic Began"
        guard timelineStartTime != nil else { return }
        touchStartTime = CACurrentMediaTime()
        startHaptic()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("**touchEnded")
        touchLabel.text = "Haptic Ended"

        guard let touchStart = touchStartTime, let globalStart = timelineStartTime else { return }
        
        let touchEnded = CACurrentMediaTime()
        let relativeStart = max(0, touchStart - globalStart)
        let relativeEnd = max(0, touchEnded - globalStart)
        
        addTouchReflection(from: relativeStart, to: relativeEnd)
        stopHaptic()
        touchStartTime = nil
    }
    
    private func addTouchReflection(from: TimeInterval, to: TimeInterval) {
        let barWidth = timelineView.bounds.width
        let startX = CGFloat(from / totalDuration) * barWidth
        let width = CGFloat((to - from) / totalDuration) * barWidth
        
        let segment = UIView(frame: CGRect(x: startX, y: timelineView.bounds.height / 4, width: max(width, 1.5), height: timelineView.bounds.height / 2))
        segment.backgroundColor = UIColor.segment
        segment.layer.cornerRadius = 2
        timelineView.addSubview(segment)
    }
}

