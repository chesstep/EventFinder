//
//  EventNetworkModel.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

struct EventNetworkModel: Decodable {
    
    let events: [Event]
    
    struct Event: Decodable {
        
        let id: Int
        let title: String
        let dateTimeLocal: String
        let performers: [Performer]
        let venue: Venue
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case dateTimeLocal = "datetime_local"
            case performers
            case venue
        }
        
        struct Performer: Decodable {
            
            let image: String?
        }
        
        struct Venue: Decodable {
            
            let city: String
            let state: String
        }
        
    }
}

extension Event {
    
    init(networkEvent: EventNetworkModel.Event) {
        id = networkEvent.id
        title = networkEvent.title
        date = DateFormatter.eventOriginationFormatter.date(from: networkEvent.dateTimeLocal)
        city = networkEvent.venue.city
        state = networkEvent.venue.state
        let imageUrls = networkEvent.performers.compactMap {
            return $0.image
        }
        imageURL = imageUrls.first
    }
}
