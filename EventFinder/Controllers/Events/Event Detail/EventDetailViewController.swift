//
//  EventDetailViewController.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Kingfisher
import UIKit

class EventDetailViewController: UIViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    
    private var rightBarButton: UIBarButtonItem!
    private let appConfiguration: AppConfiguration
    private let presenter: EventDetailPresenter
    private var event: Event
    
    init(appConfiguration: AppConfiguration, event: Event) {
        self.appConfiguration = appConfiguration
        presenter = EventDetailPresenter(appConfiguration: appConfiguration)
        self.event = event
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        presenter.attachView(view: self)
        
        title = event.title
        rightBarButton = UIBarButtonItem(image: UIImage(named: "star_empty"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(rightBarButtonPressed(sender:)))
        navigationItem.rightBarButtonItems = [rightBarButton]
        presenter.configureButtonImage(event: event)
        
        eventImageView.layer.cornerRadius = 10
        if let imageString = event.imageURL, let url = URL(string: imageString) {
            eventImageView.kf.setImage(with: url)
        }
        eventLocationLabel.text = "\(event.city), \(event.state)"
        if let date = event.date {
            eventDateLabel.text = DateFormatter.eventFormatter.string(from: date)
        }
    }
    
    @objc
    func rightBarButtonPressed(sender: UIBarButtonItem) {
        presenter.rightBarButtonPressed(event: event)
    }
}

// MARK: - EventDetailView

extension EventDetailViewController: EventDetailView {
    
    func showEmptyButtonImage() {
        rightBarButton.image = UIImage(named: "star_empty")
    }
    
    func showFilledButtonImage() {
        rightBarButton.image = UIImage(named: "star_filled")
    }
}
