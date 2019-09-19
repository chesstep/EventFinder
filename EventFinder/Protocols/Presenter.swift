//
//  Presenter.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Foundation

protocol Presenter {
    
    associatedtype View
    
    func attachView(view: View)
    func detachView()
}
