//
//  AppDelegate.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator!
    private var appConfiguration: AppConfiguration!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        appConfiguration = AppConfiguration()
        appCoordinator = AppCoordinator(window: window!, appConfiguration: appConfiguration)
        appCoordinator.start()
        
        return true
    }
}

