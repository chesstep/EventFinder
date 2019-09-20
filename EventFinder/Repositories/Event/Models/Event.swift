//
//  Event.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

struct Event: Codable & Hashable {
    
    let id: Int
    let title: String
    let date: Date?
    let city: String
    let state: String
    let imageURL: String?
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
