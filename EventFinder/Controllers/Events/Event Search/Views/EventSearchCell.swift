//
//  EventSearchCell.swift
//  EventFinder
//
//  Created by Chesley Stephens on 9/19/19.
//  Copyright © 2019 Nibbis. All rights reserved.
//

import Kingfisher
import UIKit

class EventSearchCell: UITableViewCell {
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var eventImageView: UIImageView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureData(event: Event, isFavorite: Bool) {
        favoriteImageView.isHidden = !isFavorite
        eventImageView.layer.cornerRadius = 10
        if let imageString = event.imageURL, let url = URL(string: imageString) {
            eventImageView.kf.setImage(with: url)
        } else {
            eventImageView.image = nil
        }
        eventTitleLabel.text = event.title
        eventLocationLabel.text = "\(event.city), \(event.state)"
        if let date = event.date {
            eventDateLabel.text = DateFormatter.eventFormatter.string(from: date)
        }
    }
}
