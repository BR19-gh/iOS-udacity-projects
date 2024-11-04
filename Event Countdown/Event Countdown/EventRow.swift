//
//  EventRow.swift
//  Event Countdown
//
//  Created by Ibrahim Alkhowaiter on 29/09/2024.
//

import SwiftUI

struct EventRow: View {
    var event: EventModel
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let formatter = RelativeDateTimeFormatter() // Create the relative date formatter
    
    @State private var timeRemaining: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(event.name)
                .fontWeight(.bold)
                .foregroundStyle(event.textColor)
            
            Text(timeRemaining)
                .onAppear(perform: updateTimeRemaining)
                .onReceive(timer) { _ in
                    updateTimeRemaining() // Update time every second
                }
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    //updates the timeRemaining using RelativeDateTimeFormatter
    private func updateTimeRemaining() {
        timeRemaining = formatter.localizedString(for: event.date, relativeTo: Date())
    }
}

#Preview {
    List {
        EventRow(event: EventModel(
            name: "Eid al-Fitr 🎉",
            date: Date(timeIntervalSinceNow: 24000),
            textColor: .red
        ))
        EventRow(event: EventModel(
            name: "Ramadan 🌙",
            date: Date(timeIntervalSinceNow: -86400 * 29),
            textColor: .blue
        ))
    }
}
