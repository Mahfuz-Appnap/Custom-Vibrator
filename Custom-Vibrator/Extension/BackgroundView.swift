//
//  HomeView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 4/8/25.
//

import SwiftUI

struct BackgroundView: View {

    let colors = [
        Color(red: 0.55, green: 0.34, blue: 1),
        Color(red: 0.75, green: 0.03, blue: 1)
    ]
    

    var body: some View {
        ZStack(alignment: .top) {
            Constants.SurfaceBG.edgesIgnoringSafeArea(.all)
                        
            VStack {
                RadialGradient(colors: colors,
                               center: .top, startRadius: 180, endRadius: 5)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .blur(radius: 100)
                .edgesIgnoringSafeArea(.all)
                
                Spacer()
                
                RadialGradient(colors: colors,
                               center: .bottom, startRadius: 180, endRadius: 5)
                .frame(maxWidth: .infinity)
                .frame(height: 30)
                .blur(radius: 100)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

#Preview {
    BackgroundView()
}
