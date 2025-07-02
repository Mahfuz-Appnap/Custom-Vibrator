//
//  ViewController.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 2/7/25.
//

import UIKit

class ViewController: UIViewController {
    
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
        touchLabel.text = "touchesBegan"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("**touchEnded")
        touchLabel.text = "touchEnded"
    }
    
}

