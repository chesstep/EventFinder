//
//  EventLocalDataSource.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

class EventLocalDataSource: EventDataSource {
    
    private let favoriteCache: Cache<Event>
    
    private let cacheName = "eventsCache"
    private let favoritesSet = "favoritesSet"
    
    init() {
        favoriteCache = Cache(cacheName: cacheName)
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
