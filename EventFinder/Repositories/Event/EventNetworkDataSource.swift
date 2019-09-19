//
//  EventNetworkDataSource.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

class EventNetworkDataSource: EventDataSource {
    
    private let appConfiguration: AppConfiguration
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
    }
    
    func allEvents(completion: EventDataSourceCompletion?) {
        // TOOD: Mock events
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + 2) {
            var events = [Event]()
            for index in 0..<20 {
                let event = Event(id: index, title: "Texas Rangers At Oakland As \(index)", date: Date(), city: "Dallas", state: "TX", imageURL: "https://seatgeek.com/images/performers-landscape/houston-astros-0dec05/20/huge.jpg", isFavorite: true)
                events.append(event)
            }
            
            completion?(.success(events))
        }
    }
}
