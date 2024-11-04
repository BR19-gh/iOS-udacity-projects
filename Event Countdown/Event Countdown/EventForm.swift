//
//  EventForm.swift
//  Event Countdown
//
//  Created by Ibrahim Alkhowaiter on 29/09/2024.
//

import SwiftUI

struct EventForm: View {
    
    var onSave: (EventModel) -> Void
    
    @State private var eventName: String
    @State private var eventDate: Date
    @State private var eventColor: Color
    
    @Environment(\.dismiss) var dismiss
    
    var isEditing: Bool

    // Initializer to set default values
    init(event: EventModel, isEditing: Bool, onSave: @escaping (EventModel) -> Void) {
        self.isEditing = isEditing
        self.onSave = onSave
        _eventName = State(initialValue: event.name)
        _eventDate = State(initialValue: event.date)
        _eventColor = State(initialValue: event.textColor)
    }

    var body: some View {
        Form {
            TextField("Event Name", text: $eventName)
                .foregroundColor(eventColor)
            DatePicker("Date", selection: $eventDate)
            ColorPicker("Text Color", selection: $eventColor)
        }
        .navigationTitle(isEditing ? "Edit " + eventName : "Add Event")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    let newEvent = EventModel(name: eventName, date: eventDate, textColor: eventColor)
                    onSave(newEvent)
                    dismiss()
                }) {
                    Image(systemName: "checkmark")
                }
                .disabled(eventName.isEmpty)
            }
        }
    }
}

#Preview {
    NavigationStack {
        EventForm(
            event: EventModel(name: "Event 1", date: Date(), textColor: .red),
            isEditing: true
        ) { _ in }
    }
}
