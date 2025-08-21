//
//  Font+Extensions.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 14/8/25.
//

import SwiftUI

enum PoppinFontWeight: String, CaseIterable {
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case semibold = "Poppins-SemiBold"
    case bold = "Poppins-Bold"
}

enum PoppinFont {
    static func swiftui(_ weight: PoppinFontWeight, size: CGFloat, relativeTo style: Font.TextStyle? = nil) -> Font {
        if let style {
            return Font.custom(weight.rawValue, size: size, relativeTo: style)
        } else {
            return Font.custom(weight.rawValue, size: size)
        }
    }
}

// .font(AppFont.swiftUI(.regular, size: 16, relativeTo: .body))

