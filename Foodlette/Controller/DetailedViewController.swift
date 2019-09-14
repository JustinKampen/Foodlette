//
//  DetailedViewController.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import MapKit

class DetailedViewController: UIViewController {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantCategoryLabel: UILabel!
    @IBOutlet weak var restaurantRatingImageView: UIImageView!
    @IBOutlet weak var restaurantReviewsCountLabel: UILabel!
    @IBOutlet weak var restaurantSelectedOnLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        return df
    }()
    
    var dataController = DataController.shared
    var restaurant: Restaurant?
    var foodletteWinner: Business?
    var defaultFilterSelected: DefaultFilter?
    var createdFilterSelected: Filter?
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Restaurant Details"
        mapView.delegate = self
        if let foodletteWinner = foodletteWinner {
            displayInformationFor(winner: foodletteWinner)
            displayPinLocationFor(winner: foodletteWinner)
            saveDataFor(winner: foodletteWinner)
        } else {
            showAlert(message: "There was an error selecting the winner. Please try again")
        }    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    func displayInformationFor(winner: Business) {
        restaurantNameLabel.text = winner.name
        restaurantRatingImageView.image = winner.ratingImage
        restaurantReviewsCountLabel.text = "\(String(describing: winner.reviewCount)) Reviews"
//        if defaultFilterSelected != nil {
//            if let defaultFilterSelected = defaultFilterSelected {
//                filterSelectedLabel.text = "Selected with \"\(String(defaultFilterSelected.name))\""
//            }
//        } else {
//            if let userFilterSelected = createdFilterSelected {
//                filterSelectedLabel.text = "Selected with \"\(String(userFilterSelected.name!))\""
//            }
//        }
        if let url = URL(string: winner.imageURL) {
            if let data = try? Data(contentsOf: url) {
                restaurantImageView.image = UIImage(data: data)
            }
        }
    }
    
    func displayPinLocationFor(winner: Business) {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = winner.coordinates.latitude
        annotation.coordinate.longitude = winner.coordinates.longitude
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    
    func saveDataFor(winner: Business) {
        let restaurant = Restaurant(context: dataController.viewContext)
        restaurant.name = winner.name
        print(winner)
        restaurant.category = winner.categories.first?.title
//        restaurant.withFilter = winner.
        restaurant.date = Date()
        restaurant.rating = winner.rating
        restaurant.reviewCount = "\(String(describing: winner.reviewCount)) Reviews"
        if let winnerImage = restaurantImageView.image {
            let imageData = winnerImage.jpegData(compressionQuality: 0.8)
            restaurant.image = imageData
        }
        dataController.saveViewContext()
    }
}

// -----------------------------------------------------------------------------
// MARK: - MapView

extension DetailedViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.tintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
}
