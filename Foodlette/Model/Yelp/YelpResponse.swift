//
//  YelpResponse.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import Foundation

// -----------------------------------------------------------------------------
// MARK: - Yelp Response Parsing

struct YelpResponse: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let name: String
    let imageURL: String
    let url: String
    let reviewCount: Int
    let categories: [Category]
    let rating: Double
    let coordinates: Coordinates
    
    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "image_url"
        case url
        case reviewCount = "review_count"
        case categories
        case rating
        case coordinates
    }
}

struct Category: Codable {
    let alias: String
    let title: String
}

struct Coordinates: Codable {
    let latitude: Double
    let longitude: Double
}

