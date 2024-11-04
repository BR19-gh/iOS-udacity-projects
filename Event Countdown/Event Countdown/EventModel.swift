//
//  EventModel.swift
//  Event Countdown
//
//  Created by Ibrahim Alkhowaiter on 29/09/2024.
//

import SwiftUI

struct EventModel: Identifiable, Hashable {
    var id = UUID() 
    var name: String
    var date: Date
    var textColor: Color
    
    static func == (lhs: EventModel, rhs: EventModel) -> Bool {
        return lhs.id == rhs.id
    }

    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
