//
//  EventRepository.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

typealias EventRepositoryCompletion = (Result<[Event], Error>) -> Void

class EventRepository {
    
    private let appConfiguration: AppConfiguration
    private let networkDataSource: EventDataSource
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
        
        networkDataSource = EventNetworkDataSource(appConfiguration: appConfiguration)
    }
    
    func all(completion: EventRepositoryCompletion?) {
        networkDataSource.allEvents { result in
            switch result {
            case .success(let items):
                completion?(.success(items))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}
