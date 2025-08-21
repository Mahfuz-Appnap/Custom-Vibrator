//
//  CreatePatternView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 17/8/25.
//

import SwiftUI

struct CreatePatternView: View {
    var body: some View {
        ZStack(alignment: .top) {
            
            HStack {
                
                Button {
                    //
                } label: {
                    HStack {
                        Image("stopButton")
                        Text("Stopp")
                            .font(PoppinFont.swiftui(.medium, size: 16))
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .foregroundStyle(.textPrimary)
                .background(.white)
                .containerShape(.capsule)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button {
                        //
                    } label: {
                        Image("playButton")
                            .renderingMode(.template)
                            .padding(15)
                    }
                    .background(.surfaceInactive)
                    .foregroundStyle(.white.opacity(0.4))
                    .containerShape(.circle)
                    .frame(width: 48, height: 48)
                    
                    Button {
                        //
                    } label: {
                        HStack {
                            Image("saveButton")
                                .renderingMode(.template)
                            
                            Text("Save")
                                .font(PoppinFont.swiftui(.medium, size: 16))
                        }
                        .padding(.horizontal, 10.5)
                        .padding(.vertical, 12)
                    }
                    .foregroundStyle(.white.opacity(0.4))
                    .background(.surfaceInactive)
                    .containerShape(.capsule)
                }
            }
        }
        .withGradientBackground()
    }
}

#Preview {
    CreatePatternView()
}
