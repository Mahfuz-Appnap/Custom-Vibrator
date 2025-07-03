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
    var timelineStart: TimeInterval?
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
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var playHeaderView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 20))
        view.backgroundColor = .red
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("hellow")
        view.backgroundColor = UIColor.purple
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
    
    private func setupUI() {
        view.addSubview(touchLabel)
        view.addSubview(timelineView)
        NSLayoutConstraint.activate([
            touchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touchLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            
            timelineView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timelineView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            timelineView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            timelineView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        timelineView.addSubview(playHeaderView)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.startTimeLine()
        }
    }
    
    private func startTimeLine() {
        timelineStart = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(updatePlayhead))
        displayLink?.add(to: .main, forMode: .default)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
            self.displayLink?.invalidate()
            self.playHeaderView.removeFromSuperview()
        }
    }

    @objc func updatePlayhead() {
        guard let start = timelineStart else { return }
        let elapsedTime = CACurrentMediaTime() - start
        let progress = min(1, (elapsedTime / totalDuration))
        
        let barWidth = timelineView.bounds.width
        let x = progress * barWidth
        playHeaderView.frame.origin.x = x
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("**touchesBegan")
        touchLabel.text = "Haptic Began"
        guard timelineStart != nil else { return }
        startHaptic()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("**touchEnded")
        touchLabel.text = "Haptic Ended"
        stopHaptic()
    }
    
}

