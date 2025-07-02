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

    
    private lazy var touchLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        NSLayoutConstraint.activate([
            touchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touchLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        ])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("**touchesBegan")
        touchLabel.text = "Haptic Began"
        startHaptic()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("**touchEnded")
        touchLabel.text = "Haptic Ended"
        stopHaptic()
    }
    
}

