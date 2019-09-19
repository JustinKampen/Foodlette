//
//  DefaultFilter.swift
//  Foodlette
//
//  Created by Justin on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// -----------------------------------------------------------------------------
// MARK: - Default Filter Model

struct DefaultFilter {
    let name: String
    let narrative: String
    let category: String?
    let minRating: Double?
    let maxRating: Double?
    let favorites: Bool?
    let image: UIImage
}

let defaultFilter = [
    DefaultFilter(name: "Random", narrative: "All Categories", category: nil, minRating: 1.0, maxRating: 5.0, favorites: false, image: #imageLiteral(resourceName: "burger-chips-dinner")),
    DefaultFilter(name: "Select From Favorites", narrative: "All Categories from Favorites", category: nil, minRating: 1.0, maxRating: 5.0, favorites: true, image: #imageLiteral(resourceName: "asparagus-barbecue-bbq")),
    DefaultFilter(name: "4+ Rating", narrative: "All Categories", category: nil, minRating: 4.0, maxRating: 5.0, favorites: false, image: #imageLiteral(resourceName: "burrito-chicken-close-up")),
    DefaultFilter(name: "Good Morning", narrative: "Breakfest", category: "breakfest", minRating: 3.0, maxRating: 5.0, favorites: false, image: #imageLiteral(resourceName: "blur-close-up-dairy-product"))
]
