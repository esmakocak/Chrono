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

    @GestureState private var dragOffset: CGSize = .zero
    @State private var offsetX: CGFloat = 0
    @State private var showTrash = false

    var body: some View {
        ZStack(alignment: .trailing) {
            // 🗑️ Delete arka plan
            HStack {
                Spacer()
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
                    .padding(.trailing, 24)
            }
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .cornerRadius(30)

            // 🧾 Görev Kartı
            HStack(alignment: .top) {
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
                        .font(.system(size: 18))
                        .foregroundColor(.black)

                    Text(task.formattedDuration)
                        .font(.footnote)
                        .foregroundColor(.gray)
                }

                Spacer()

                if !task.isCompleted {
                    Button(action: onStart) {
                        Image(systemName: "play.fill")
                            .foregroundColor(Color("Burgundy"))
                    }
                    .buttonStyle(.plain)
                } else {
                    Image(systemName: "play.fill")
                        .foregroundColor(Color("Burgundy").opacity(0.4))
                }
            }
            .padding()
            .background(Color("LightPeach"))
            .cornerRadius(30)
            .offset(x: offsetX + dragOffset.width)
            .gesture(
                DragGesture()
                    .updating($dragOffset) { value, state, _ in
                        if value.translation.width < 0 {
                            state = value.translation
                        }
                    }
                    .onEnded { value in
                        if value.translation.width < -100 {
                            withAnimation {
                                offsetX = -500
                            }
                            HapticsManager.shared.notify(.warning)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                onDelete()
                            }
                        } else {
                            withAnimation {
                                offsetX = 0
                            }
                        }
                    }
            )
        }
        .animation(.easeInOut(duration: 0.2), value: offsetX)
    }
}
