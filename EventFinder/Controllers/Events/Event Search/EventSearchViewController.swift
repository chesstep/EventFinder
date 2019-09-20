//
//  EventSearchViewController.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import UIKit

protocol EventSearchViewControllerDelegate: class {
    
    func didSelectEvent(event: Event)
}

class EventSearchViewController: UIViewController {
    
    enum State {
        case start
        case empty
        case loading
        case events
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    weak var delegate: EventSearchViewControllerDelegate?
    
    private let appConfiguration: AppConfiguration
    private let presenter: EventSearchPresenter
    private let searchController: UISearchController
    
    private var events = [Event]()
    private var selectedEvent: Event?
    
    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
        presenter = EventSearchPresenter(appConfiguration: appConfiguration)
        searchController = UISearchController(searchResultsController: nil)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func configureUI() {
        title = NSLocalizedString("Event Finder", comment: "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        presenter.attachView(view: self)
        tableView.register(UINib(nibName: String(describing: EventSearchCell.self), bundle: nil), forCellReuseIdentifier: String(describing: EventSearchCell.self))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search Events", comment: "")
        searchController.searchBar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        setViewState(state: .start)
    }
    
    func setViewState(state: State) {
        switch state {
        case .start:
            tableView.isHidden = true
            loadingIndicator.isHidden = true
            actionLabel.isHidden = false
            actionLabel.text = NSLocalizedString("Use the search bar above to begin finding events", comment: "")
        case .loading:
            tableView.isHidden = true
            loadingIndicator.isHidden = false
            actionLabel.isHidden = true
        case .empty:
            tableView.isHidden = true
            loadingIndicator.isHidden = true
            actionLabel.isHidden = false
            actionLabel.text = NSLocalizedString("No events found :(", comment: "")
        case .events:
            tableView.isHidden = false
            loadingIndicator.isHidden = true
            actionLabel.isHidden = true
        }
    }
}

// MARK: - UITableViewDataSource

extension EventSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        if let eventSearchCell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventSearchCell.self), for: indexPath) as? EventSearchCell {
            let event = events[indexPath.row]
            eventSearchCell.configureData(event: event, isFavorite: appConfiguration.eventRepository.eventIsFavorite(event: event))
            cell = eventSearchCell
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EventSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectEvent(event: events[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - EventSearchView

extension EventSearchViewController: EventSearchView {
    
    func setState(state: State) {
        setViewState(state: state)
    }
    
    func setEvents(events: [Event]) {
        self.events = events
        tableView.reloadData()
    }
    
    func presentAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UISearchResultsUpdating

extension EventSearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        presenter.queryEvents(query: searchController.searchBar.text)
    }
}

// MARK: - Keyboard Notifications

extension EventSearchViewController {
    
    @objc
    func keyboardWillShow(_ notification:Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    @objc
    func keyboardWillHide(_ notification:Notification) {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
