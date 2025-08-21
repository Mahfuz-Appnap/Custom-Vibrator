//
//  SegementedControlSwiftui.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 19/8/25.
//

import SwiftUI
import UIKit

#Preview {
    PatternView()
}

enum SegmentType: CaseIterable{
    case preset
    case custom
    case another
    
    var name: String{
        switch self {
        case .preset:
            return "Preset"
        case .custom:
            return "Custom"
        case .another:
            return "Another"
        }
    }
}

//UISegment for SwiftUI
struct SegmentedControl: UIViewRepresentable {
    @Binding var selectedIndex: Int
    var items: [String]
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.selectedSegmentIndex = selectedIndex
    }
    
    
    func makeUIView(context: Context) -> VibratorSegmentedControl {
        let segmentedControl = VibratorSegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = selectedIndex

        segmentedControl.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        
        return segmentedControl
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: SegmentedControl
        
        init(_ parent: SegmentedControl) {
            self.parent = parent
        }
        
        @objc func valueChanged(_ sender: UISegmentedControl) {
            parent.selectedIndex = sender.selectedSegmentIndex
        }
    }
}


class VibratorSegmentedControl: UISegmentedControl {
    private let segmentInset: CGFloat = 5
    private let segmentImage: UIImage? = nil
    
    override func layoutSubviews(){
        super.layoutSubviews()
        
        //background
        layer.cornerRadius = bounds.height/2
        layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        setTitleTextAttributes([.foregroundColor: UIColor.textPrimary], for: .selected)
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView
        {
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentInset, dy: segmentInset)
            foregroundImageView.image = segmentImage    //substitute with our own colored image
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")    //this removes the weird scaling animation!
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height/2
            foregroundImageView.backgroundColor = UIColor.white
        }
    }
}


//MARK: - jjj

struct SegmentedItem: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var systemImage: String? = nil
}

struct VibratorSegmentedControlView: View {
    @Binding var selection: Int
    var items: [SegmentedItem]

    // Styling
    var height: CGFloat = 44
    var containerColor: Color = Color.black.opacity(0.25)   // dark pill bg
    var selectedColor: Color = .white                       // selected pill
    var selectedTextColor: Color = Color(#colorLiteral(red: 0.20, green: 0.08, blue: 0.32, alpha: 1)) // your purple/dark
    var normalTextColor: Color = .white.opacity(0.85)
    var font: Font = PoppinFont.swiftui(.medium, size: 16)

    @Namespace private var ns

    var body: some View {
        GeometryReader { geo in
            let segmentWidth = geo.size.width / CGFloat(max(1, items.count))

            ZStack(alignment: .leading) {
                // Container
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(containerColor)

                // Moving selected pill
                RoundedRectangle(cornerRadius: height / 2, style: .continuous)
                    .fill(selectedColor)
                    .frame(width: segmentWidth - 4, height: height - 4)
                    .offset(x: CGFloat(selection) * segmentWidth + 2)
                    .matchedGeometryEffect(id: "vibrator", in: ns)
                    .animation(.spring(response: 0.25, dampingFraction: 1), value: selection)

                HStack(spacing: 0) {
                    ForEach(items.indices, id: \.self) { idx in
                        Button {
                            selection = idx
                        } label: {
                            HStack(spacing: 6) {
                                Text(items[idx].title)

                                if let symbol = items[idx].systemImage {
                                    Image(systemName: symbol)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .font(font)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(selection == idx ? selectedTextColor : normalTextColor)
                        .frame(width: segmentWidth, height: height)
                    }
                }
            }
            .frame(height: height)
        }
        .frame(height: height)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("VibratorSegmentedControl")
    }
}

// MARK: - Example usage matching your screenshot
struct VibrationPatternsHeader: View {
    @State private var selected = 0
    private let tabs = [
        SegmentedItem(title: "Preset"),
        SegmentedItem(title: "Custom", systemImage: "plus.circle.fill")
    ]

    var body: some View {
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
    }
}

