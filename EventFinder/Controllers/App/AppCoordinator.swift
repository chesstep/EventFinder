//
//  AppCoordinator.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let appConfiguration: AppConfiguration
    
    private let eventSearchCoordinator: EventSearchCoordinator
    
    init(window: UIWindow, appConfiguration: AppConfiguration) {
        self.window = window
        self.appConfiguration = appConfiguration
        self.eventSearchCoordinator = EventSearchCoordinator(window: window, appConfiguration: appConfiguration)
    }
    
    func start() {
        eventSearchCoordinator.start()
    }
}
