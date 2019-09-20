//
//  EventNetworkDataSourceMock.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 9/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation
@testable import EventFinder

class EventNetworkDataSourceMock: EventDataSource {
    
    var dataSourceCompletionResult: Result<[Event], Error>?
    
    func queryEvents(query: String, completion: EventDataSourceCompletion?) {
        if let dataSourceCompletionResult = dataSourceCompletionResult {
            completion?(dataSourceCompletionResult)
        }
    }
    
    func addFavoriteEvent(event: Event) { }
    func removeFavoriteEvent(event: Event) { }
    func eventIsFavorite(event: Event) -> Bool { return false }
}
