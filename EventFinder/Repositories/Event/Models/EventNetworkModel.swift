//
//  EventNetworkModel.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

struct EventNetworkModel: Decodable {
    
    let title: String
}

extension Event {
    
    init(eventNetworkModel: EventNetworkModel) {
        id = 1
        title = eventNetworkModel.title
        date = Date()
        city = eventNetworkModel.title
        state = eventNetworkModel.title
        imageURL = eventNetworkModel.title
        isFavorite = false
    }
}
