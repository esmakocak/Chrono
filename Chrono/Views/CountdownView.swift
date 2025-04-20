//
//  CountdownView.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import SwiftUI

struct CountdownView: View {
    @ObservedObject var viewModel: CountdownViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color("BgColor").ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Top Bar
                HStack {
                    Button {
                        viewModel.stopTimer()
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(Color("Burgundy"))
                            .padding()
                    }
                    Spacer()
                }
                .padding(.top)

                // Task Title
                Text(viewModel.task.title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color("Burgundy"))
                    .padding(.bottom, 20)

                // Progress Ring
                ZStack {
                    Circle()
                        .stroke(Color("LightPeach"), lineWidth: 20)
                        .frame(width: 220, height: 220)

                    Circle()
                        .trim(from: 0.0, to: viewModel.progress)
                        .stroke(Color("Burgundy"), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 220, height: 220)
                        .animation(.linear(duration: 1), value: viewModel.timeRemaining)

                    Text(viewModel.formattedTime)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color("Burgundy"))
                }
                .padding(.bottom, 40)

                // Pause / Resume Button
                Button {
                    viewModel.toggleTimer()
                } label: {
                    Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(Color("Burgundy")))
                }
                .padding(.bottom, 20)

                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
    }
}

#Preview {
    NavigationStack {
        CountdownView(viewModel: CountdownViewModel(task: TaskModel(
            id: UUID(),
            title: "Sample Task",
            duration: 20,
            isCompleted: false,
            date: Date()
        )))
    }
}
