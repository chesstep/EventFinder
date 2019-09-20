//
//  EventLocalDataSourceMock.swift
//  EventFinderTests
//
//  Created by Chesley Stephens on 9/20/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation
@testable import EventFinder

class EventLocalDataSourceMock: EventDataSource {
    
    let favoriteCache: Cache<Event>
    
    let cacheName = "testEventsCache"
    let favoritesSet = "testFavoritesSet"
    
    init() {
        favoriteCache = Cache(cacheName: "testFavoriteCache", useDiskCache: false)
    }
    
    func queryEvents(query: String, completion: EventDataSourceCompletion?) {
        completion?(.success([Event]()))
    }
    
    func addFavoriteEvent(event: Event) {
        var existingFavorites = favoriteCache.object(key: favoritesSet) ?? Set<Event>()
        existingFavorites.insert(event)
        favoriteCache.setObject(object: existingFavorites, key: favoritesSet)
    }
    
    func removeFavoriteEvent(event: Event) {
        var existingFavorites = favoriteCache.object(key: favoritesSet) ?? Set<Event>()
        existingFavorites.remove(event)
        favoriteCache.setObject(object: existingFavorites, key: favoritesSet)
    }
    
    func eventIsFavorite(event: Event) -> Bool {
        let existingFavorites = favoriteCache.object(key: favoritesSet)
        return existingFavorites?.contains(event) ?? false
    }
}
