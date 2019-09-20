//
//  EventDataSource.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

typealias EventDataSourceCompletion = (Result<[Event], Error>) -> Void

protocol EventDataSource {
    
    func queryEvents(query: String, completion: EventDataSourceCompletion?)
    
    func addFavoriteEvent(event: Event)
    func removeFavoriteEvent(event: Event)
    func eventIsFavorite(event: Event) -> Bool
}
