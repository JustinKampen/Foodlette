//
//  DetailedViewController.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var restaurantRatingImageView: UIImageView!
    @IBOutlet weak var restaurantReviewsCountLabel: UILabel!
    @IBOutlet weak var restaurantSelectedOnLabel: UILabel!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }()
    
    var restaurant: Restaurant?
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Restaurant Details"
        displayInformationFor(restaurant)
        print(restaurant!)
    }
    
    func displayRatingImage(for rating: Double) -> UIImage {
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
        return ratingImage
    }
    
    func displayInformationFor(_ restaurant: Restaurant?) {
        if let restaurant = restaurant {
            restaurantNameLabel.text = restaurant.name
            restaurantCategoryLabel.text = restaurant.category
            if let imageData = restaurant.image {
                restaurantImageView.image = UIImage(data: imageData)
            }
            restaurantRatingImageView.image = displayRatingImage(for: restaurant.rating)
            restaurantReviewsCountLabel.text = restaurant.reviewCount
            if let date = restaurant.date {
                restaurantSelectedOnLabel.text = dateFormatter.string(from: date)
        }
//            filterUsedLabel.text = "Filter used: \(String(describing: restaurant.withFilter))"
        }
    }
}
