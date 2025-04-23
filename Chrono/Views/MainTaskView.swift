//
//  MainTaskView.swift
//  Chrono
//
//  Created by Esma Koçak on 1.03.2025.
//

import SwiftUI

struct MainTaskView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var isPresentingAddTask = false
    @State private var selectedTaskForCountdown: TaskEntity?
    @Environment(\.scenePhase) private var scenePhase
    @State private var currentDay = Calendar.current.startOfDay(for: Date())
    @State private var refreshTrigger = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("BgColor").ignoresSafeArea()

                VStack {
                    // Top bar
                    HStack {
                        Button {
                            authManager.signOut()
                        } label: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("Burgundy"))
                        }

                        Spacer()

                        Text(formattedDate)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color("Burgundy"))
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    Spacer(minLength: 20)

                    // Task list
                    VStack(spacing: 15) {
                        ForEach(sortedTasks) { task in
                            HStack(alignment: .top) {
                                // Tamamla butonu
                                Button {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        viewModel.toggleCompletion(for: task)
                                    }
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(task.isCompleted ? Color("Burgundy") : .clear)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color("Burgundy"), lineWidth: 3)
                                            )
                                            .animation(.easeInOut(duration: 0.25), value: task.isCompleted)

                                        if task.isCompleted {
                                            Image(systemName: "checkmark")
                                                .font(.system(size: 12, weight: .bold))
                                                .foregroundColor(.white)
                                                .transition(.scale.combined(with: .opacity))
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
                                    Button {
                                        selectedTaskForCountdown = task
                                    } label: {
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
                            .padding(.horizontal)
                        }
                    }

                    Spacer()
                }

                // FAB
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isPresentingAddTask = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .font(.system(size: 28))
                                .frame(width: 60, height: 60)
                                .background(Circle().fill(Color("Burgundy")))
                        }
                        .padding()
                        .sheet(isPresented: $isPresentingAddTask) {
                            AddTaskView(viewModel: viewModel)
                        }
                    }
                }
            }
            .fullScreenCover(item: $selectedTaskForCountdown) { task in
                CountdownView(viewModel: CountdownViewModel(task: task))
                    .environmentObject(viewModel)
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    let today = Calendar.current.startOfDay(for: Date())
                    if today != currentDay {
                        currentDay = today
                        refreshTrigger.toggle()
                    }
                }
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E MMM dd"
        return formatter.string(from: Date())
    }

    private var sortedTasks: [TaskEntity] {
        _ = refreshTrigger
        let todayTasks = viewModel.tasks.filter { $0.isToday }
        let incomplete = todayTasks.filter { !$0.isCompleted }
        let complete = todayTasks.filter { $0.isCompleted }
        return incomplete + complete
    }
}

//#Preview {
//    MainTaskView()
//        .environmentObject(AuthManager())
//        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//}

#Preview {
    MainTaskView()
        .environmentObject(TaskViewModel(context: PersistenceController.shared.container.viewContext))
        .environmentObject(AuthManager())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
