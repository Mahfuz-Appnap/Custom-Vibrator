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
        SettingItem(title: "Privacy Policy", iconName: "privacy"),
    ]
        
    private var unLockSettings: [SettingItem] = [
        SettingItem(title: "No vibration?", iconName: "vibrator"),
        SettingItem(title: "Get Premium", iconName: "crown"),
        SettingItem(title: "Restore Purchase", iconName: "rotate-cw"),
    ]

    
    let cardColor = Color(red: 53 / 255, green: 12 / 255, blue: 77 / 255)
    
    
    var body: some View {
        ZStack(alignment: .top) {

            VStack(spacing: 25) {
                
                Image("unLockAll")
                
                VStack {
                    ForEach(unLockSettings) { setting in
                        SettingRow(title: setting.title, iconName: setting.iconName)
                    }
                }
                .padding()
                .background(cardColor)
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("Other")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    VStack(spacing: 16) {
                        ForEach(settings) { setting in
                            SettingRow(title: setting.title, iconName: setting.iconName)
                        }
                    }
                    .padding()
                    .background(cardColor)
                    .cornerRadius(16)
                }
            }
        }
        .withGradientBackground()
        .navigationTitle("Setting")

    }
}

#Preview {
    NoVibratorFreeView()
}
