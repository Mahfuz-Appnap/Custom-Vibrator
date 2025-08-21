//
//  NoVibratorFreeView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 4/8/25.
//

import SwiftUI

struct NoVibratorFreeView: View {
    
    private var settings: [SettingItem] = [
        SettingItem(title: "Contact Support", iconName: "contact"),
        SettingItem(title: "Terms and Conditions", iconName: "terms"),
        SettingItem(title: "Privacy Policy", iconName: "privacy")
    ]
        
    private var unLockSettings: [SettingItem] = [
        SettingItem(title: "No vibration?", iconName: "vibrator"),
        SettingItem(title: "Get Premium", iconName: "crown"),
        SettingItem(title: "Restore Purchase", iconName: "rotate-cw")
    ]

    
    let cardColor = Color(hex: "#350C4D")
    
    
    var body: some View {
        ZStack(alignment: .top) {

            ScrollView(.vertical) {
                VStack(spacing: 25) {
                    
                    Image("unLockAll")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 10)
                        .frame(height: 168)
                        .clipped()
                    
                    VStack(spacing: 5)  {
                        ForEach(unLockSettings) { setting in
                            SettingRow(title: setting.title, iconName: setting.iconName)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(cardColor)
                    .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Other")
                            .foregroundColor(.white)
                            .font(PoppinFont.swiftui(.medium, size: 17))
                        
                        VStack(spacing: 5) {
                            ForEach(settings) { setting in
                                SettingRow(title: setting.title, iconName: setting.iconName)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(cardColor)
                        .cornerRadius(12)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .withGradientBackground()
        .navigationTitle("Setting")
    }
}

#Preview {
    NoVibratorFreeView()
}
