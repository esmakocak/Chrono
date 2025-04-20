//
//  AddTaskView.swift
//  Chrono
//
//  Created by Esma Koçak on 20.04.2025.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TaskViewModel

    @State private var title: String = ""
    @State private var selectedMinutes: Int = 30
    @State private var selectedHours: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                // Başlık
                HStack {
                    Spacer()
                    
                    Text("Add New Task")
                        .font(.system(size: 20))
                        .fontWeight(.heavy)
                        .foregroundStyle(Color("Burgundy"))
                        .padding(.top, 25)
                    
                    Spacer()
                }

                // Görev Başlığı TextField
                VStack(spacing: 8) {
                    TextField("Task Title", text: $title)
                        .autocapitalization(.none)
                        .bold()
                        .textFieldStyle(.plain)
                        .padding(.top, 20)
                        .padding(.leading, 15)
                        .padding(.bottom, 5)

                    Rectangle()
                        .frame(width: 350, height: 1)
                        .foregroundStyle(Color("Burgundy"))
                }
                
                // Time Interval Başlığı
                HStack {
                    Text("Time Interval")
                        .font(.system(size: 17))
                        .fontWeight(.semibold)
                        .foregroundStyle(Color("Burgundy"))
                        .padding(.leading, 15)
                        .padding(.top, 35)
                        .padding(.bottom, -20)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()
                }
                
                // Wheel style picker
                HStack(spacing: 0) {
                    Picker("Saat", selection: $selectedHours) {
                        ForEach(0..<13, id: \.self) { hour in
                            Text("\(hour) saat").tag(hour)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150)

                    Picker("Dakika", selection: $selectedMinutes) {
                        ForEach([0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55], id: \.self) { minute in
                            Text("\(minute) dk").tag(minute)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150)
                }
                .frame(height: 120)

                // Görev Ekle Butonu
                Button(action: {
                    let totalSeconds = TimeInterval((selectedHours * 60 + selectedMinutes) * 60)
                    viewModel.addTask(title: title, duration: totalSeconds)
                    dismiss()
                }) {
                    Text("Add Task")
                        .foregroundColor(Color("BgColor"))
                        .font(.system(size: 20, weight: .medium))
                        .padding()
                        .frame(width: 200, height: 55)
                        .background(title.isEmpty ? Color.gray.opacity(0.5) : Color("Burgundy"))
                        .cornerRadius(50)
                        .padding(.top, 30)
                }
                .disabled(title.isEmpty)
            
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .padding(.horizontal)
            .background(Color("BgColor"))
        }
        .background(Color("BgColor"))
        .ignoresSafeArea()
    }
}

#Preview {
    AddTaskView(viewModel: TaskViewModel())
}
