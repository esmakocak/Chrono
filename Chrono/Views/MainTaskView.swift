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
    @Environment(\.scenePhase) private var scenePhase

    @State private var isPresentingAddTask = false
    @State private var selectedCountdownVM: CountdownViewModel?
    @State private var today = Calendar.current.startOfDay(for: Date())

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
                    .padding(.bottom)

                    Spacer(minLength: 20)

                    // Task list
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(sortedTasks) { task in
                                TaskCardView(
                                    task: task,
                                    onDelete: {
                                        viewModel.delete(task: task)
                                        HapticsManager.shared.notify(.warning)
                                    },
                                    onToggle: {
                                        viewModel.toggleCompletion(for: task)
                                    },
                                    onStart: {
                                        selectedCountdownVM = CountdownViewModel(task: task)
                                    }
                                )
                            }
                        }
                        .padding(.top)
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
            .fullScreenCover(item: $selectedCountdownVM) { vm in
                CountdownView(viewModel: vm)
                    .environmentObject(viewModel)
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    let newDay = Calendar.current.startOfDay(for: Date())
                    if today != newDay {
                        today = newDay
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
        let todayTasks = viewModel.tasks.filter { $0.isToday }
        let incomplete = todayTasks.filter { !$0.isCompleted }
        let complete = todayTasks.filter { $0.isCompleted }
        return incomplete + complete
    }
}
