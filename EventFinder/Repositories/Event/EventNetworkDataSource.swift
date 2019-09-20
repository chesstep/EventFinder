//
//  EventNetworkDataSource.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

class SeatGeekAuthenticator: AuthenticatorProtocol {
    
    let clientId = "MTg0ODY2MjZ8MTU2ODg2MTE4MC4zNA"
    let clientSecret = "19192aba2c7100ba2d4b5057e4548ce5ce599dc50d9d48c4c5df9e5c9dfee158"
    
    func addAuthentication(requestConfiguration: RequestConfiguration, urlRequest: URLRequest, completion: @escaping AuthenticationCompletion) {
        if let idSecret = "\(clientId):\(clientSecret)".data(using: .utf8)?.base64EncodedString() {
            let authenticationString = "Basic \(idSecret)"
            
            var newURLRequest = urlRequest
            newURLRequest.addValue(authenticationString, forHTTPHeaderField: "Authorization")
            completion(.success(newURLRequest))
        } else {
            completion(.failure(NetworkError.authenticationFailure))
        }        
    }
}

class EventNetworkDataSource: EventDataSource {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func queryEvents(query: String, completion: EventDataSourceCompletion?) {
        let parameters = ["q": query]
        let authenticator = SeatGeekAuthenticator()
        let requestConfiguration = RequestConfiguration(endpoint: "https://api.seatgeek.com/2/events", httpMethod: .get, authenticator: authenticator, parameters: parameters)
        networkManager.executeRequest(requestConfiguration: requestConfiguration, responseModel: EventNetworkModel.self) { result in
            switch result {
            case .success(let dataResponse):
                var events = [Event]()
                if let eventNetworkModel = dataResponse.data as? EventNetworkModel {
                    events = eventNetworkModel.events.map {
                        return Event(networkEvent: $0)
                    }
                }
                completion?(.success(events))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func addFavoriteEvent(event: Event) { }
    func removeFavoriteEvent(event: Event) { }
    
    func eventIsFavorite(event: Event) -> Bool {
        return false
    }
}
