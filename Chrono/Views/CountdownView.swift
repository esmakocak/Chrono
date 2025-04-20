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
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var showCompletedAlert = false
    @State private var showExitConfirmation = false

    var body: some View {
        ZStack {
            Color("BgColor").ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Top Bar
                HStack {
                    Button {
                        viewModel.isRunning = false
                        showExitConfirmation = true
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
                Text(viewModel.task.title ?? "task")
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
            
            viewModel.onCountdownFinished = {
                taskViewModel.complete(task: viewModel.task)
                showCompletedAlert = true
            }
        }
        .onDisappear {
            viewModel.stopTimer()
            viewModel.timeRemaining = viewModel.task.duration
        }
        .alert("Are you sure you want to quit?", isPresented: $showExitConfirmation) {
            Button("Yes, Quit", role: .destructive) {
                viewModel.stopTimer()
                dismiss()
            }
            Button("Cancel", role: .cancel) {
                viewModel.isRunning = true 
            }
        } message: {
            Text("If you leave now, your progress will be lost.")
        }
        .alert("Task Completed 🎉", isPresented: $showCompletedAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("“\(viewModel.task.title ?? "task")” has been marked as completed.")
        }
    }
}

#Preview {
    let context = PersistenceController.shared.container.viewContext
    let task = TaskEntity(context: context)
    task.id = UUID()
    task.title = "Sample Task"
    task.duration = 20
    task.isCompleted = false
    task.date = Date()

    return NavigationStack {
        CountdownView(viewModel: CountdownViewModel(task: task))
            .environmentObject(TaskViewModel(context: context))
            .environment(\.managedObjectContext, context)
    }
}
