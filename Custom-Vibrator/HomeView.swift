//
//  HomeView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 19/8/25.
//

import SwiftUI

// MARK: - Data

struct Pattern: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let symbol: String
}

enum PatternTab: String, CaseIterable, Identifiable, CustomStringConvertible {
    case preset = "Preset"
    case custom = "Custom"
    var id: String { rawValue }
    var description: String { rawValue }
}

// Version-safe symbol resolver
private func symbolName(for title: String) -> String {
    if #available(iOS 16, *) {
        switch title {
        case "Ocean":    return "water.waves"
        case "Rain":     return "cloud.rain"
        case "Wind":     return "wind"
        case "Volcano":  return "mountain.2"
        case "Electric": return "bolt"
        case "Rainbow":  return "rainbow"
        case "Wave":     return "waveform.path"
        case "Vibrator": return "dot.radiowaves.left.and.right"
        case "Galaxy":   return "sparkles"
        case "Drill":    return "screwdriver"
        case "Meteor":   return "shooting.star"
        case "Guitar":   return "guitars"
        case "Drum":     return "drumsticks"
        case "Mindful":  return "brain.head.profile"
        default:         return "circle"
        }
    } else {
        switch title {
        case "Ocean":    return "water.waves"
        case "Rain":     return "cloud.rain"
        case "Wind":     return "wind"
        case "Volcano":  return "flame"
        case "Electric": return "bolt"
        case "Rainbow":  return "rainbow"
        case "Wave":     return "waveform.path"
        case "Vibrator": return "dot.radiowaves.left.and.right"
        case "Galaxy":   return "sparkles"
        case "Drill":    return "wrench.and.screwdriver"
        case "Meteor":   return "star"
        case "Guitar":   return "music.note"
        case "Drum":     return "music.note.list"
        case "Mindful":  return "brain"
        default:         return "circle"
        }
    }
}

// Titles to display
private let patternTitles: [String] = [
    "Ocean","Rain","Wind",
    "Volcano","Electric","Rainbow",
    "Wave","Vibrator","Galaxy",
    "Drill","Meteor","Guitar",
    "Drum","Mindful"
]

// Build array once
private let patterns: [Pattern] = patternTitles.map {
    Pattern(title: $0, symbol: symbolName(for: $0))
}

// MARK: - Screen

struct VibrationPatternsView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedPattern: Pattern? = patterns.first
    @State private var tab: PatternTab = .preset

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color(hex: 0x3D0F54), Color(hex: 0x1B0826)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                header
                segmented

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(patterns) { p in
                            PatternCard(
                                title: p.title,
                                symbol: p.symbol,
                                isSelected: p == selectedPattern, isPremium: true
                            )
                            .onTapGesture {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                                    selectedPattern = p
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
            }
            .padding(.top, 8)
        }
        .navigationBarHidden(true)
        .preferredColorScheme(.dark)
    }

    // MARK: Header
    private var header: some View {
        HStack(spacing: 12) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white.opacity(0.95))
                    .padding(10)
                    .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            Text("Vibration Patterns")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Spacer()
        }
        .padding(.horizontal, 16)
    }

    // MARK: Segmented
    private var segmented: some View {
        SegmentedCapsule(selection: $tab, items: PatternTab.allCases)
            .padding(.horizontal, 16)
    }
}

// MARK: - Components
struct SegmentedCapsule<T: Hashable & Identifiable & CustomStringConvertible>: View where T: CaseIterable {
    @Binding var selection: T
    let items: [T]

    init(selection: Binding<T>, items: [T]) {
        self._selection = selection
        self.items = items
    }

    var body: some View {
        let outer = Capsule()

        ZStack(alignment: .leading) {
            outer.fill(Color.white.opacity(0.08))

            GeometryReader { geo in
                let w = geo.size.width / CGFloat(items.count)
                let index = CGFloat(items.firstIndex(of: selection) ?? 0)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
                    .frame(width: w - 6, height: geo.size.height - 6)
                    .offset(x: index * w + 3)
                    .animation(.spring(response: 0.28, dampingFraction: 0.9), value: selection)
            }

            HStack(spacing: 0) {
                ForEach(items) { item in
                    Button { selection = item } label: {
                        Text(item.description)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 38)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(selection == item ? Color(hex: 0x35123F) : .white.opacity(0.9))
                }
            }
            .padding(3)
        }
        .frame(height: 44)
        .clipShape(outer)
    }
}

// MARK: - Helpers

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}

// MARK: - Preview

struct VibrationPatternsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { VibrationPatternsView() }
            .preferredColorScheme(.dark)
    }
}

