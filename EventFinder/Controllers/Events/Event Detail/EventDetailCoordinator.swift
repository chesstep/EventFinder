//
//  EventDetailCoordinator.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import UIKit

class EventDetailCoordinator: Coordinator {
    
    private let appConfiguration: AppConfiguration
    private let navigationController: UINavigationController
    private let event: Event
    
    init(navigationController: UINavigationController, appConfiguration: AppConfiguration, event: Event) {
        self.navigationController = navigationController
        self.appConfiguration = appConfiguration
        self.event = event
    }
    
    func start() {
        let eventDetailViewController = EventDetailViewController(appConfiguration: appConfiguration, event: event)
        navigationController.pushViewController(eventDetailViewController, animated: true)
    }
}
