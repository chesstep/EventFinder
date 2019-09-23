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
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor(named: "navigationTint")
        navigationBarAppearace.titleTextAttributes = [.foregroundColor: UIColor(named: "navigationTitle") ?? .white]
        navigationBarAppearace.barTintColor = UIColor(named: "navigationBar")
        navigationBarAppearace.isTranslucent = false
        
        navigationController = UINavigationController(rootViewController: eventSearchViewController)
        
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
