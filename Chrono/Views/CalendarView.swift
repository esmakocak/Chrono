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
                let incomplete = all.filter { !$0.isCompleted }

                let totalSeconds = completed.reduce(0) { $0 + Int($1.duration) }
                let hours = totalSeconds / 3600
                let minutes = (totalSeconds % 3600) / 60
                let formattedTime = hours > 0 ? "\(hours)h \(minutes)m" : "\(minutes)m"
                let percentage = all.isEmpty ? 0 : Int(Double(completed.count) / Double(all.count) * 100)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        if all.isEmpty {
                            Text("No tasks recorded on this day.")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        } else {
                            // ✅ İstatistik yazıları
                            VStack(alignment: .leading, spacing: 6) {
                                (
                                    Text("👩🏻‍💻 Completed ") +
                                    Text("\(completed.count) out of \(all.count)")
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
                            .frame(maxWidth: .infinity, alignment: .leading)

                            // ✅ / ❌ Görevler
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
                    .padding(.horizontal)
                    .padding(.top)
                }
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
