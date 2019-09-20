//
//  EventSearchCoordinator.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import UIKit

class EventSearchCoordinator: Coordinator {
    
    private let window: UIWindow
    private let appConfiguration: AppConfiguration
    private var navigationController: UINavigationController!
    
    private var eventDetailCoordinator: EventDetailCoordinator?
    
    init(window: UIWindow, appConfiguration: AppConfiguration) {
        self.window = window
        self.appConfiguration = appConfiguration
    }
    
    func start() {
        let eventSearchViewController = EventSearchViewController(appConfiguration: appConfiguration)
        eventSearchViewController.delegate = self
        
        navigationController = UINavigationController(rootViewController: eventSearchViewController)
        navigationController.navigationBar.tintColor = .white
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.navigationBar.barTintColor = .rangerBlue
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

// MARK: - EventSearchViewControllerDelegate

extension EventSearchCoordinator: EventSearchViewControllerDelegate {
    
    func didSelectEvent(event: Event) {
        eventDetailCoordinator = EventDetailCoordinator(navigationController: navigationController, appConfiguration: appConfiguration, event: event)
        eventDetailCoordinator?.start()
    }
}
