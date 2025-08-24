//
//  CustomPatternListView.swift
//  Custom-Vibrator
//
//  Created by Appnap Technologies Ltd on 21/8/25.
//

import SwiftUI

let customPatterns: [CustomPattern] = [
    CustomPattern(title: "Shades of the night city", createdTime: Date()),
    CustomPattern(title: "Glimmering streetlights", createdTime: Date()),
    CustomPattern(title: "Silent alleys", createdTime: Date()),
    CustomPattern(title: "Whispers in the dark", createdTime: Date()),
    CustomPattern(title: "Empty park benches", createdTime: Date()),
    CustomPattern(title: "Distant sirens", createdTime: Date()),
    CustomPattern(title: "Morning fog rising", createdTime: Date()),
    CustomPattern(title: "Awakening city", createdTime: Date()),
    CustomPattern(title: "Bustling streets", createdTime: Date()),
]

struct CustomPatternListView: View {
    
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a • dd:MM:yyyy"
        return formatter.string(from: date).lowercased()
    }
    
    @State private var showDeleteAlert = false
    
    let column = [GridItem(.flexible(), spacing: 24)]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                ScrollView {
                    LazyVGrid(columns: column, spacing: 16) {
                        ForEach(customPatterns.indices, id: \.self) { pos in
                            VStack(alignment: .leading) {
                                    Text("\(pos.description). \(customPatterns[pos].title)")
                                        .font(PoppinFont.swiftui(.semibold, size: 20))
                                        .foregroundStyle(pos == 0 ? .buttonSecondary : .white1)
                                
                                Text(formattedDate(from: customPatterns[pos].createdTime))
                                    .font(PoppinFont.swiftui(.regular, size: 12))
                                    .foregroundStyle(.white.opacity(0.5))
                                    .padding(.leading, 22)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 22)
                        }
                        .onLongPressGesture {
                            showDeleteAlert = true
                        }
                    }
                }
            }
            
            Button {
                print("Create button pressed!")
//                showDeleteAlert = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.whitesecondary)
                    .frame(width: 48, height: 48)
                    .background(.buttonSecondary)
                    .clipShape(.circle)
                    .shadow(radius: 5)
            }
            .padding(25)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Are you sure?"),
                message: Text(
                    "Do you really want to delete this custom pattern?"
                ),
                primaryButton: .cancel(
                    Text("Cancel"),
                    action: cancelPressed
                ),
                secondaryButton: .destructive(
                    Text("Delete"),
                    action: deletePressed
                )
            )
        }
        .withGradientBackground()
    }
    
    func cancelPressed() {
        print("cancel triggered")
    }
    
    func deletePressed() {
        print("delete triggered")
    }
}

#Preview {
    CustomPatternListView()
}

struct CustomPattern {
    let id = UUID()
    let title: String
    let createdTime: Date
}
