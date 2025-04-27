//
//  TaskCardView.swift
//  Chrono
//
//  Created by Esma Koçak on 23.04.2025.
//

import SwiftUI

struct TaskCardView: View {
    let task: TaskEntity
    let onDelete: () -> Void
    let onToggle: () -> Void
    let onStart: () -> Void

    @State private var dragOffset = CGSize.zero
    @State private var position = CGSize.zero

    var body: some View {
        ZStack(alignment: .trailing) {
            // DELETE BACKGROUND CIRCLE AS BUTTON
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(Color("Burgundy"))
                        .frame(width: 50, height: 50)

                    Button {
                        withAnimation(.easeInOut) {
                            onDelete()
                        }
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(Color("BgColor"))
                            .font(.system(size: 20, weight: .bold))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.trailing, 20)
            }

            // MAIN CARD CONTENT
            HStack {
                Button {
                    withAnimation {
                        onToggle()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .frame(width: 25, height: 25)
                            .foregroundColor(task.isCompleted ? Color("Burgundy") : .clear)
                            .overlay(Circle().stroke(Color("Burgundy"), lineWidth: 3))

                        if task.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(.plain)

                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title ?? "")
                        .strikethrough(task.isCompleted)
                        .font(.system(size: 17))
                        .foregroundColor(.black)

                    Text(task.formattedDuration)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 8)

                Spacer()

                if !task.isCompleted {
                    Button(action: onStart) {
                        Image(systemName: "play.fill")
                            .foregroundColor(Color("Burgundy"))
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 5)
                } else {
                    Image(systemName: "play.fill")
                        .foregroundColor(Color("Burgundy").opacity(0.4))
                        .padding(.trailing, 5)
                }
            }
            .padding()
            .background(Color("LightPeach"))
            .cornerRadius(20)
            .padding(.horizontal, 10)
            .offset(x: dragOffset.width + position.width)
            .contentShape(Rectangle())
            .highPriorityGesture(
                DragGesture()
                    .onChanged { value in
                        let horizontal = abs(value.translation.width)
                        let vertical = abs(value.translation.height)

                        // 🔐 Sadece yatay hareket belirginse swipe başlasın
                        if horizontal > vertical && value.translation.width < 0 {
                            withAnimation(.easeOut(duration: 0.1)) {
                                dragOffset = value.translation
                            }
                        }
                    }
                    .onEnded { value in
                        let horizontal = abs(value.translation.width)
                        let vertical = abs(value.translation.height)

                        withAnimation(.easeInOut) {
                            if horizontal > vertical && value.translation.width < -50 {
                                position.width = -80
                            } else {
                                position.width = 0
                            }
                            dragOffset = .zero
                        }
                    }
            )
        }
        .frame(height: 80)
    }
}
