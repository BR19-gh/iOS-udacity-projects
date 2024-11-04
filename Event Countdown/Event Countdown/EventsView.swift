//
//  EventsView.swift
//  Event Countdown
//
//  Created by Ibrahim Alkhowaiter on 29/09/2024.
//

import SwiftUI

struct EventsView: View {
    
    @State var events: [EventModel] = []
    
    enum Mode: Hashable {
        case add
        case edit(EventModel)
    }
    
    @State private var selectedMode: Mode? = nil

    var body: some View {
        NavigationStack {
            List {
                if events.isEmpty {
                    ContentUnavailableView(
                        "No events yet",
                        systemImage: "calendar.badge.plus",
                        description: Text("Add new event by tapping the plus icon.")
                    )
                } else {
                    ForEach(events.sorted(by: { $0.date < $1.date })) { event in
                        NavigationLink(value: Mode.edit(event)) {
                            EventRow(event: event)
                        }
                        .swipeActions {
                            Button("Delete") {
                                if let index = events.firstIndex(where: { $0.id == event.id }) {
                                    events.remove(at: index)
                                }
                            }.tint(.red)
                        }
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: Mode.add) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .navigationDestination(for: Mode.self) { mode in
                switch mode {
                case .add:
                    EventForm(
                        event: EventModel(name: "", date: Date(), textColor: .black),
                        isEditing: false
                    ) { newEvent in
                        events.append(newEvent)  // Add new event to the list
                    }
                case .edit(let editedEvent):
                    EventForm(
                        event: editedEvent,
                        isEditing: true
                    ) { updatedEvent in
                        if let index = events.firstIndex(where: { $0.id == editedEvent.id }) {
                            events[index] = updatedEvent  // Update the event in the list
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    EventsView()
}
