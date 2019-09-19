//
//  EventDetailPresenter.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

protocol EventDetailView: class {
    
    func setEvent(event: Event)
    func showEmptyButtonImage()
    func showFilledButtonImage()
}

class EventDetailPresenter: Presenter {
    
    private let appConfiguration: AppConfiguration
    private weak var view: EventDetailView!
    private let eventRepository: EventRepository
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
        eventRepository = EventRepository(appConfiguration: appConfiguration)
    }
    
    func attachView(view: EventDetailView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
    func configureButtonImage(event: Event) {
        if event.isFavorite {
            view?.showFilledButtonImage()
        } else {
            view?.showEmptyButtonImage()
        }
    }
    
    func rightBarButtonPressed(event: Event) {
        let newEvent = Event(id: event.id, title: event.title, date: event.date, city: event.city, state: event.state, imageURL: event.imageURL, isFavorite: !event.isFavorite)
        view?.setEvent(event: newEvent)
    }
}
