//
//  CalendarView.swift
//  Chrono
//
//  Created by Esma Koçak on 21.04.2025.
//

import SwiftUI

struct CalendarView: View {
    var body: some View {
        ZStack {
            Color("BgColor").ignoresSafeArea()
            Text("Calendar View")
                .font(.title)
                .foregroundColor(Color("Burgundy"))
        }
    }
}

#Preview {
    CalendarView()
}
