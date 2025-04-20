//
//  MainTaskView.swift
//  Chrono
//
//  Created by Esma Koçak on 1.03.2025.
//

import SwiftUI

struct MainTaskView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var viewModel = TaskViewModel()
    @State private var isPresentingAddTask = false
    
    var body: some View {
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
                    ForEach(viewModel.tasks.filter { $0.isToday }) { task in
                        HStack {
                            Button {
                                viewModel.toggleCompletion(for: task)
                            } label: {
                                ZStack {
                                    Circle()
                                        .stroke(Color("Burgundy"), lineWidth: 3)
                                        .frame(width: 25, height: 25)
                                    
                                    if task.isCompleted {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.white)
                                            .font(.system(size: 12))
                                            .padding(6)
                                            .background(Circle().fill(Color("Burgundy")))
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                                .font(.system(size: 18))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image(systemName: "play.fill")
                                .foregroundColor(Color("Burgundy"))
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
                            .shadow(radius: 5)
                    }
                    .padding()
                    .sheet(isPresented: $isPresentingAddTask) {
                        AddTaskView(viewModel: viewModel)
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
}

#Preview {
    MainTaskView()
        .environmentObject(AuthManager())
}
