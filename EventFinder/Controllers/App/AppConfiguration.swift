//
//  AppConfiguration.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

class AppConfiguration {
    
    var networkManager: NetworkManager
    var eventRepository: EventRepository
    
    init() {
        networkManager = NetworkManager()
        eventRepository = EventRepository(networkManager: networkManager)
    }
}
