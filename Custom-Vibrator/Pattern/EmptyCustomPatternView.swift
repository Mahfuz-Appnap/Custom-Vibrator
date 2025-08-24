//
//  EmptyCustomPatternView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 21/8/25.
//

import SwiftUI

struct EmptyCustomPatternView: View {
    var body: some View {
        
        VStack(spacing: 48) {
            VStack(spacing: 32) {
                Image("newPattern")
                    .frame(width: 94, height: 94)
                
                VStack(spacing: 16) {
                    Text("Create New Pattern")
                        .font(PoppinFont.swiftui(.medium, size: 24))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                    
                    Text("Play around, get creative, and make vibrations that feel just right.")
                        .font(PoppinFont.swiftui(.regular, size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
            .padding(.horizontal, 47)
            
            Button {
                //
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Create New")
                }
                .padding(.vertical, 18)
                .font(PoppinFont.swiftui(.bold, size: 18))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .background(.buttonSecondary)
            .clipShape(.capsule)
            .padding(.horizontal, 20)
        }
        .withGradientBackground()
    }
}

#Preview {
    EmptyCustomPatternView()
}
//Button(action: {}) {
//    Text("Go to Setting")
//        .padding(.vertical)
//        .foregroundColor(.white)
//        .frame(maxWidth: .infinity)
//}
//.background(Color.buttonSecondary)
//.clipShape(.capsule)
//.padding(.horizontal, 20)
