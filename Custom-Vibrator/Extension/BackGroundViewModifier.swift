//
//  BackGroundView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 4/8/25.
//

import SwiftUI

struct BackGroundViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            BackgroundView()
            content
        }
    }
}


extension View {
    func withGradientBackground() -> some View {
        self.modifier(BackGroundViewModifier())
    }
}
