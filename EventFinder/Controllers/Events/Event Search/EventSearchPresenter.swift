//
//  EventSearchPresenter.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

protocol EventSearchView: class {
    
    func setState(state: EventSearchViewController.State)
    func setEvents(events: [Event])
    func presentAlert(title: String?, message: String?)
}

class EventSearchPresenter: Presenter {
    
    private let appConfiguration: AppConfiguration
    private weak var view: EventSearchView!
    private let eventRepository: EventRepository
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
        eventRepository = EventRepository(appConfiguration: appConfiguration)
    }
    
    func attachView(view: EventSearchView) {
        self.view = view
    }
    
    func detachView() {
        view = nil
    }
    
    func loadEvents() {
        view.setState(state: .loading)
        eventRepository.all { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    self?.view.setEvents(events: events)
                    self?.view.setState(state: .events)
                case .failure(let error):
                    self?.view.presentAlert(title: NSLocalizedString("Event Error", comment: ""), message: error.localizedDescription)
                    self?.view.setState(state: .empty)
                }
            }
        }
    }
}
