//
//  SettingsView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 3/8/25.
//

import SwiftUI

struct SettingItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
}

struct SettingsView: View {
    
    let primaryColor = Color(red: 30 / 255, green: 0 / 255, blue: 60 / 255)
       let cardColor = Color(red: 53 / 255, green: 12 / 255, blue: 77 / 255)
    
    
    private var settings: [SettingItem] = [
        SettingItem(title: "Contact Support", iconName: "contact"),
        SettingItem(title: "Terms and Conditions", iconName: "terms"),
        SettingItem(title: "Privacy Policy", iconName: "rotate-cw"),
    ]
    
    
    var body: some View {
            
        ZStack(alignment: .top) {

            VStack(spacing: 25) {
                VStack {
                    SettingRow(title: "No Vibrator?", iconName: "vibrator")
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
        
    }
}

//MARK: Row Template
struct SettingRow: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            HStack(spacing: 20) {
                Image(iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.white)
        }
        .font(.body.weight(.bold))
        .padding(.trailing, 20)
        .padding(.vertical, 12)
    }
}



#Preview {
    SettingsView()
}
