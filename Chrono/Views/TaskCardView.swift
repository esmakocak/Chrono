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

    var body: some View {
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
        .padding(.horizontal)
        .padding(.bottom, 10)
    }
}
