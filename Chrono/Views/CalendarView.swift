import SwiftUI

struct CalendarView: View {
    @Environment(\.calendar) var calendar
    @EnvironmentObject var taskViewModel: TaskViewModel
    @StateObject private var vm: CalendarViewModel

    @State private var isYearSelectionPresented = false

    init() {
        _vm = StateObject(wrappedValue: CalendarViewModel(viewModel: TaskViewModel(context: PersistenceController.shared.container.viewContext)))
    }

    var body: some View {
        VStack(spacing: 16) {
            header

            if isYearSelectionPresented {
                yearGrid
            } else {
                weekdayHeaders
                dayGrid

                if let selected = vm.selectedDate {
                    ScrollView {
                        statsView(for: selected)
                            .padding(.horizontal)
                            .padding(.top)
                    }
                }
            }

            Spacer()
        }
        .padding(.top)
        .background(Color("BgColor").ignoresSafeArea())
    }

    private var header: some View {
        HStack {
            Button {
                withAnimation {
                    if isYearSelectionPresented {
                        vm.incrementYear(by: -1)
                    } else {
                        vm.goToPreviousMonth()
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color("Burgundy"))
            }

            Spacer()

            Button {
                withAnimation {
                    isYearSelectionPresented.toggle()
                }
            } label: {
                Text(isYearSelectionPresented ?
                     String(calendar.component(.year, from: vm.currentDate)) :
                     vm.currentDate.formatted(.dateTime.year().month()))
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color("Burgundy"))
            }

            Spacer()

            Button {
                withAnimation {
                    if isYearSelectionPresented {
                        vm.incrementYear(by: 1)
                    } else {
                        vm.goToNextMonth()
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(Color("Burgundy"))
            }
        }
        .padding(.horizontal)
    }

    private var weekdayHeaders: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
            ForEach(vm.weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
    }

    private var dayGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
            ForEach(0..<vm.leadingSpaces, id: \.self) { _ in Color.clear.frame(height: 36) }

            ForEach(vm.currentMonthDates, id: \.self) { date in
                let ratio = vm.ratio(for: date)
                let isToday = vm.isToday(date)
                let isSelected = vm.isSelected(date)

                Circle()
                    .fill(Color("Burgundy").opacity(ratio == 0 ? 0.1 : 0.4 + (0.6 * ratio)))
                    .frame(width: isToday ? 42 : 36, height: isToday ? 42 : 36)
                    .overlay(
                        Text("\(calendar.component(.day, from: date))")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                    )
                    .overlay(
                        Circle().stroke(Color.black, lineWidth: isSelected ? 2 : 0)
                    )
                    .onTapGesture {
                        withAnimation { vm.select(date) }
                    }
            }
        }
        .padding(.horizontal)
    }

    private var yearGrid: some View {
        let months = calendar.monthSymbols
        let currentYear = calendar.component(.year, from: vm.currentDate)

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
            ForEach(0..<12) { index in
                Button {
                    withAnimation {
                        isYearSelectionPresented = false
                        vm.setMonth(index, year: currentYear)
                    }
                } label: {
                    Text(months[index])
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color("Burgundy"))
                        .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }

    private func statsView(for date: Date) -> some View {
        let (completed, incomplete, formattedTime, percentage) = vm.stats(for: date)

        return VStack(alignment: .leading, spacing: 16) {
            if completed.isEmpty && incomplete.isEmpty {
                Text("No tasks recorded on this day.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            } else {
                HStack {
                    Rectangle()
                        .frame(width: 3, height: 80)
                        .foregroundStyle(Color("Burgundy"))

                    VStack(alignment: .leading, spacing: 6) {
                        (
                            Text("👩🏻‍💻 Completed ") +
                            Text("\(completed.count) out of \(completed.count + incomplete.count)")
                                .foregroundColor(Color("Burgundy"))
                                .fontWeight(.semibold) +
                            Text(" tasks.")
                        )

                        (
                            Text("🚀 Reached ") +
                            Text("\(percentage)%")
                                .foregroundColor(Color("Burgundy"))
                                .fontWeight(.semibold) +
                            Text(" of your goals.")
                        )

                        (
                            Text("🧠 Focused for ") +
                            Text(formattedTime)
                                .foregroundColor(Color("Burgundy"))
                                .fontWeight(.semibold) +
                            Text(".")
                        )
                    }
                    .font(.subheadline)
                    .foregroundColor(.black)
                }

                VStack(alignment: .leading, spacing: 20) {
                    if !completed.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("✓ Completed Tasks")
                                .font(.subheadline)
                                .foregroundColor(Color("Burgundy"))
                                .bold()
                            ForEach(completed, id: \.self) { task in
                                Text(task.title ?? "")
                                    .font(.footnote)
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color("LightPeach"))
                                    .cornerRadius(10)
                            }
                        }
                    }

                    if !incomplete.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("✕ Incomplete Tasks")
                                .font(.subheadline)
                                .foregroundColor(Color("Burgundy"))
                                .bold()
                            ForEach(incomplete, id: \.self) { task in
                                Text(task.title ?? "")
                                    .font(.footnote)
                                    .padding(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color("LightPeach").opacity(0.4))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    MainTaskView()
        .environmentObject(TaskViewModel(context: PersistenceController.shared.container.viewContext))
        .environmentObject(AuthManager())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
