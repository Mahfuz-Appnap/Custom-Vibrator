//
//  PatternView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 19/8/25.
//

import SwiftUI

enum PatternType: Int, CaseIterable {
    case ocean = 0
    case rain
    case wind
    case volcano
    case electric
    case rainbow
    case wave
    case vibrator
    case galaxy
    case drill
    case meteor
    case guitar
    case drum
    case mindful
    
    var title: String {
        switch self {
        case .ocean:
            "Ocean"
        case .rain:
            "Rain"
        case .wind:
            "Wind"
        case .volcano:
            "Volcano"
        case .electric:
            "Electro"
        case .rainbow:
            "Rainbow"
        case .wave:
            "Wave"
        case .vibrator:
            "Vibrator"
        case .galaxy:
            "Galaxy"
        case .drill:
            "Drill"
        case .meteor:
            "Meteor"
        case .guitar:
            "Guitar"
        case .drum:
            "Drum"
        case .mindful:
            "Mindful"
        }
    }
        
    var icon: String {
        switch self {
        case .ocean:
            "ocean"
        case .rain:
            "rain"
        case .wind:
            "wind"
        case .volcano:
            "volcano"
        case .electric:
            "electro"
        case .rainbow:
            "rainbow"
        case .wave:
            "wave"
        case .vibrator:
            "vibrator"
        case .galaxy:
            "galaxy"
        case .drill:
            "drill"
        case .meteor:
            "meteor"
        case .guitar:
            "guitar"
        case .drum:
            "drum"
        case .mindful:
            "mindful"
        }
    }
}


struct PatternView: View {
    @State private var selected = 0
    private var patternCols = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    private let tabs = [
        SegmentedItem(title: "Preset"),
        SegmentedItem(title: "Custom", systemImage: "plus.circle.fill")
    ]
    
    private let patterns: [PatternType] = PatternType.allCases
    @State var selectedPattern: PatternType? = .wave

    
    var body: some View {
        
        VStack(spacing: 0) {
            VibratorSegmentedControlView(
                selection: $selected,
                items: tabs,
                height: 44,
                containerColor: Color.white.opacity(0.12),
                selectedColor: .white,
                selectedTextColor: Color(red: 0.36, green: 0.16, blue: 0.69),
                normalTextColor: .white.opacity(0.9)
            )
            .padding(.horizontal, 20)
            
            ScrollView(.vertical) {
                LazyVGrid(columns: patternCols, spacing: 16) {
                    ForEach(patterns, id: \.rawValue) { pattern in
                        PatternCard(
                            title: pattern.title,
                            symbol: pattern.icon,
                            isSelected: pattern == selectedPattern,
                            isPremium: pattern.rawValue > 3 ? true : false
                        )
                        .onTapGesture {
                            print(pattern)
                            selectedPattern = pattern
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
        .withGradientBackground()
    }
}


//MARK: Pattern Card
struct PatternCard: View {
    let title: String
    let symbol: String
    let isSelected: Bool
    let isPremium: Bool

    var body: some View {
        let base = RoundedRectangle(cornerRadius: 22, style: .continuous)

        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(.buttonSecondary))
                .overlay(base.strokeBorder(Color.white.opacity(0.35), lineWidth: 1))
                .shadow(color: Color(hex: 0xFF4DA6).opacity(0.55), radius: 18, x: 0, y: 10)
            } else {
                base.fill(Color.surfaceBg2)
                    .overlay(base.strokeBorder(Color.white.opacity(0.08), lineWidth: 1))
            }

            VStack(alignment: .center, spacing: 10) {
                Image(symbol)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.92))
                    .frame(width: 48, height: 48)

                Text(title)
                    .font(PoppinFont.swiftui(.regular, size: 14))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.85))
            }
            .padding(.vertical, 18)
            
            if isPremium {
                HStack(alignment: .top) {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Image("premium")
                            .foregroundStyle(.yellow)
                        Spacer()
                    }
                    .padding(.vertical, -6)
                }
                .padding(.horizontal, -6)
            }
        }
//        .frame(height: 104)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}


#Preview {
    PatternView()
}
