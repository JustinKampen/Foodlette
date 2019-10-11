//
//  Favorable.swift
//  Foodlette
//
//  Created by Justin Kampen on 9/24/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

// MARK: - Favorable Protocol
// Handles marking restaurant as favorite

protocol Favorable: class {
    
    func didTapFavoriteButton(for restaurant: Restaurant)
}
