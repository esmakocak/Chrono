//
//  CalendarView.swift
//  Chrono
//
//  Created by Esma Koçak on 21.04.2025.
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.calendar) var calendar
    @Environment(\.managedObjectContext) var context
    @EnvironmentObject var viewModel: TaskViewModel

    private var currentMonthDates: [Date] {
        let today = Date()
        guard let range = calendar.range(of: .day, in: .month, for: today),
              let monthInterval = calendar.dateInterval(of: .month, for: today) else {
            return []
        }

        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: monthInterval.start)
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            // 🗓️ Ay başlığı
            Text(Date().formatted(.dateTime.year().month()))
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)

            // 📆 Takvim 7 sütunlu grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                ForEach(currentMonthDates, id: \.self) { date in
                    let ratio = viewModel.completionStats()[calendar.startOfDay(for: date)] ?? 0.0
                    Circle()
                        .fill(Color("Burgundy").opacity(ratio == 0 ? 0.1 : 0.4 + (0.6 * ratio)))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Text("\(calendar.component(.day, from: date))")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .semibold))
                        )
                }
            }
            .padding()
        }
        .background(Color("BgColor").ignoresSafeArea())
    }
}

//#Preview {
//    CalendarView(viewModel: TaskViewModel(context: PersistenceController.shared.container.viewContext))
//        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
//}

#Preview {
    MainTaskView()
        .environmentObject(TaskViewModel(context: PersistenceController.shared.container.viewContext))
        .environmentObject(AuthManager())
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
