//
//  FavoritesTableViewCell.swift
//  Foodlette
//
//  Created by Justin on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

protocol Favorable: class {
    
    func didTapFavoriteButton(for restaurant: Restaurant)
}

class FavoritesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteNameLabel: UILabel!
    @IBOutlet weak var favoriterestaurantCategoryLabel: UILabel!
    @IBOutlet weak var favoriteRatingImageView: UIImageView!
    @IBOutlet weak var favoriteReviewCountLabel: UILabel!
    @IBOutlet weak var isFavoriteButton: UIButton!
    
    // -------------------------------------------------------------------------
    // MARK: - Favoriting
    
    var restaurant: Restaurant?
    weak var delegate: Favorable?
    
    func setRestaurants(favorite: Restaurant) {
        restaurant = favorite
    }
    
    @IBAction func isFavoriteButtonTapped(_ sender: Any) {
        if let restaurant = restaurant,
            let delegate = delegate {
            delegate.didTapFavoriteButton(for: restaurant)
        }
    }
}
