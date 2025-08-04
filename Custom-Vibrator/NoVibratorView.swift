//
//  NoVibratorView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 3/8/25.
//

import SwiftUI

struct NoVibratorView: View {
    
    @State private var selectedIndex = 0

    let carouselImages = ["noVibrator", "noVibrator2"]
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack(spacing: 100) {
                VStack(spacing: 30) {
                    VStack(alignment: .center, spacing: 20) {
                        Text("Make sure That Vibration and Haptic Feedback Are Enabled in your device settings")
                        
                        
                        Group {
                            if selectedIndex == 0 {
                                Text("1. Check vibration during a call and in silent mode")
                                    .font(.body.bold())
                                    .transition(.opacity)
                                Text("Settings ➜ Sound & Haptics ➜ Ringtone and Alerts ➜ Haptics")
                                    .transition(.opacity)
                            } else {
                                Text("2. Check vibration on your phone")
                                    .font(.body.bold())
                                    .transition(.opacity)
                                Text("Settings ➜ Accessibility ➜ Touch ➜ Vibration")
                                    .transition(.opacity)
                            }
                        }
                        .animation(.easeInOut, value: selectedIndex)
                    }
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    
                 
                    ImageCarouselView(images: carouselImages, selectedIndex: $selectedIndex)
                    
                }
                
                Button(action: {}) {
                    Text("Go to Setting")
                        .padding(.vertical)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .background(Color(red: 1, green: 0.4, blue: 0.7))
                .clipShape(.capsule)
                .padding(.horizontal, 20)
            }
        }
        .withGradientBackground()
        .navigationTitle("No Vibrator?")
    }
}

#Preview {
    NoVibratorView()
}


//MARK: Carousel View
struct ImageCarouselView: View {
    let images: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        VStack(spacing: 16) {
                TabView(selection: $selectedIndex) {
                    ForEach(images.indices, id: \.self) { index in
                        VStack(spacing: 0) {
                            Image(images[index])
                                .scaledToFit()
                            Spacer()
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut, value: selectedIndex)
        }
    }
}


struct TextVM: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(.red)
    }
}
