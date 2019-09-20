//
//  EventDetailPresenter.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

protocol EventDetailView: class {
    
    func showEmptyButtonImage()
    func showFilledButtonImage()
}

class EventDetailPresenter: Presenter {
    
    private let appConfiguration: AppConfiguration
    private weak var view: EventDetailView!
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
    }
    
    func attachView(view: EventDetailView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
    func configureButtonImage(event: Event) {
        if appConfiguration.eventRepository.eventIsFavorite(event: event) {
            view?.showFilledButtonImage()
        } else {
            view?.showEmptyButtonImage()
        }
    }
    
    func rightBarButtonPressed(event: Event) {
        if appConfiguration.eventRepository.eventIsFavorite(event: event) {
            appConfiguration.eventRepository.removeFavorite(event: event)
        } else {
            appConfiguration.eventRepository.addFavorite(event: event)
        }
        configureButtonImage(event: event)
    }
}
