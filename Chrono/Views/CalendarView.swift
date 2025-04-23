import SwiftUI

struct CalendarView: View {
    @Environment(\.calendar) var calendar
    @EnvironmentObject var viewModel: TaskViewModel
    @State private var currentDate = Date()
    @State private var selectedDate: Date? = nil

    private var currentMonthDates: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentDate) else { return [] }
        var dates: [Date] = []
        var date = monthInterval.start
        while date < monthInterval.end {
            dates.append(date)
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        return dates
    }

    private var leadingSpaces: Int {
        let weekday = calendar.component(.weekday, from: currentMonthDates.first!)
        let adjusted = weekday - calendar.firstWeekday
        return adjusted < 0 ? adjusted + 7 : adjusted
    }

    private var weekdaySymbols: [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let first = calendar.firstWeekday - 1
        return Array(symbols[first...] + symbols[..<first])
    }

    var body: some View {
        VStack(spacing: 16) {
            // 🔁 Ay başlığı ve oklar
            HStack {
                Button {
                    currentDate = calendar.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
                    selectedDate = nil
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color("Burgundy"))
                }

                Spacer()

                Text(currentDate.formatted(.dateTime.year().month()))
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color("Burgundy"))

                Spacer()

                Button {
                    currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
                    selectedDate = nil
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("Burgundy"))
                }
            }
            .padding(.horizontal)

            // 🗓️ Gün başlıkları
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7)) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)

            // 📅 Günler
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                // Spacerlar
                ForEach(0..<leadingSpaces, id: \.self) { _ in
                    Color.clear.frame(height: 36)
                }

                ForEach(currentMonthDates, id: \.self) { date in
                    let stats = viewModel.completionStats()
                    let ratio = stats[calendar.startOfDay(for: date)] ?? 0.0
                    let isSelected = calendar.isDate(date, inSameDayAs: selectedDate ?? Date.distantPast)

                    Circle()
                        .fill(Color("Burgundy").opacity(ratio == 0 ? 0.1 : 0.4 + (0.6 * ratio)))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text("\(calendar.component(.day, from: date))")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: isSelected ? 3 : 0)
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedDate = calendar.startOfDay(for: date)
                            }
                        }
                }
            }
            .padding(.horizontal)

            // 📊 Seçilen günün istatistikleri
            if let selected = selectedDate {
                let all = viewModel.tasksByDate()[selected] ?? []
                let completed = all.filter { $0.isCompleted }

                VStack(spacing: 6) {
                    Text(selected.formatted(date: .long, time: .omitted))
                        .font(.headline)
                        .foregroundColor(Color("Burgundy"))

                    if all.isEmpty {
                        Text("No tasks recorded on this day.")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    } else {
                        Text("You completed \(completed.count) of \(all.count) tasks.")
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                }
                .padding(.top)
            }

            Spacer()
        }
        .padding(.top)
        .background(Color("BgColor").ignoresSafeArea())
    }
}

#Preview {
    MainTaskView()
        .environmentObject(TaskViewModel(context: PersistenceController.shared.container.viewContext))
        .environmentObject(AuthManager())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
