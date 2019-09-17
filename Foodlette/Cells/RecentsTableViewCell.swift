//
//  RecentsTableViewCell.swift
//  Foodlette
//
//  Created by Justin on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

protocol RecentFavorable: class {
    
    func didTapFavoriteButton(for restaurant: Restaurant)
}

class RecentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recentNameLabel: UILabel!
    @IBOutlet weak var recentFilterSelectedLabel: UILabel!
    @IBOutlet weak var recentDateLabel: UILabel!
    @IBOutlet weak var recentImageView: UIImageView!
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    var restaurant: Restaurant?
    weak var delegate: RecentFavorable?
    
    func setRestaurants(recent: Restaurant) {
        restaurant = recent
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if let restaurant = restaurant,
            let delegate = delegate {
            delegate.didTapFavoriteButton(for: restaurant)
        }
    }
}
