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
            // DELETE BUTTON BACKGROUND
            HStack {
                Spacer()
                Button {
                    withAnimation(.easeInOut) {
                        onDelete()
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color("Burgundy"))
                            .frame(width: 50, height: 50)

                        Image(systemName: "trash")
                            .foregroundColor(Color("BgColor"))
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                .padding(.trailing, 20)
            }

            // MAIN CARD
            mainCard
                .offset(x: dragOffset.width + position.width)
                .gesture(dragGesture)
        }
        .frame(height: 80)
        .clipped() // overflow'ları kes
    }

    private var mainCard: some View {
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
        .contentShape(Rectangle())
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)

                if horizontal > vertical {
                    withAnimation(.easeOut(duration: 0.1)) {
                        dragOffset = value.translation
                    }
                }
            }
            .onEnded { value in
                let horizontal = abs(value.translation.width)
                let vertical = abs(value.translation.height)

                withAnimation(.easeInOut) {
                    if horizontal > vertical {
                        if value.translation.width < -50 {
                            position.width = -80 // Swipe left to show delete
                        } else if value.translation.width > 50 {
                            position.width = 0 // Swipe right to hide delete
                        }
                    }
                    dragOffset = .zero
                }
            }
    }
}
