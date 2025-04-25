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
                    List {
                        ForEach(sortedTasks) { task in
                            TaskCardView(
                                task: task,
                                onDelete: {
                                    viewModel.delete(task: task)
                                },
                                onToggle: {
                                    viewModel.toggleCompletion(for: task)
                                },
                                onStart: {
                                    selectedTaskForCountdown = task
                                }
                            )
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.delete(task: task)
                                    HapticsManager.shared.notify(.warning)

                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .background(Color("BgColor"))

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

#Preview {
    MainTaskView()
        .environmentObject(AuthManager())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
