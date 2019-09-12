//
//  YelpModel.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

// -----------------------------------------------------------------------------
// MARK: - Yelp Data Model

class YelpModel {
    static var data = [Business]()
}

extension Business {
    var ratingImage: UIImage {
        switch rating {
        case 0.0...0.9: return #imageLiteral(resourceName: "small_0")
        case 1.0...1.4: return #imageLiteral(resourceName: "small_1")
        case 1.5...1.9: return #imageLiteral(resourceName: "small_1_half")
        case 2.0...2.4: return #imageLiteral(resourceName: "small_2")
        case 2.5...2.9: return #imageLiteral(resourceName: "small_2")
        case 3.0...3.4: return #imageLiteral(resourceName: "small_3")
        case 3.5...3.9: return #imageLiteral(resourceName: "small_3_half")
        case 4.0...4.4: return #imageLiteral(resourceName: "small_4")
        case 4.5...4.9: return #imageLiteral(resourceName: "small_4_half")
        case 5.0: return #imageLiteral(resourceName: "small_5")
        default:
            return #imageLiteral(resourceName: "small_0")
        }
    }
}
