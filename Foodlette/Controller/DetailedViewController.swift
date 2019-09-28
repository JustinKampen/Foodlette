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
    var favoriteWinner: Restaurant?
    var foodletteWinner: Business?
    var favoritesFilterSelected: DefaultFilter?
    var defaultFilterSelected: DefaultFilter?
    var createdFilterSelected: Filter?
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if let favoriteWinner = favoriteWinner {
            displayInformationFor(favoriteWinner)
            displayPinLocationFor(favoriteWinner)
            saveDataFor(favorite: favoriteWinner)
        } else if let foodletteWinner = foodletteWinner {
            displayInformationFor(winner: foodletteWinner)
            displayPinLocationFor(winner: foodletteWinner)
            saveDataFor(winner: foodletteWinner)
        } else if let restaurant = restaurant {
            displayInformationFor(restaurant)
            displayPinLocationFor(restaurant)
        } else {
            showAlert(message: "There was an error loading restaurant data")
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Functionality
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let restaurantName = restaurantNameLabel.text else {
            showAlert(message: "There was an error sharing the restaurant")
            return
        }
        let restaurantImage = [restaurantImageView.image]
        let activityView = UIActivityViewController(activityItems: [restaurantName, restaurantImage], applicationActivities: nil)
        present(activityView, animated: true, completion: nil)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Display
    
    func displayInformationFor(_ restaurant: Restaurant) {
        restaurantNameLabel.text = restaurant.name
        restaurantCategoryLabel.text = restaurant.category
        restaurantRatingImageView.image = YelpModel.displayRatingImage(for: restaurant.rating)
        restaurantReviewsCountLabel.text = restaurant.reviewCount
        if let imageData = restaurant.image {
            restaurantImageView.image = UIImage(data: imageData)
        }
        if let date = restaurant.date {
            restaurantSelectedOnLabel.text = dateFormatter.string(from: date)
        }
    }
    
    func displayInformationFor(winner: Business) {
        restaurantNameLabel.text = winner.name
        restaurantRatingImageView.image = YelpModel.displayRatingImage(for: winner.rating)
        restaurantReviewsCountLabel.text = "\(String(describing: winner.reviewCount)) Reviews"
        let date = Date()
        restaurantSelectedOnLabel.text = dateFormatter.string(from: date)
        if let url = URL(string: winner.imageURL) {
            if let data = try? Data(contentsOf: url) {
                restaurantImageView.image = UIImage(data: data)
            }
        }
    }
    
    func displayPinLocationFor(_ restaurant: Restaurant) {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = restaurant.latitude
        annotation.coordinate.longitude = restaurant.longitude
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    
    func displayPinLocationFor(winner: Business) {
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = winner.coordinates.latitude
        annotation.coordinate.longitude = winner.coordinates.longitude
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 2500, longitudinalMeters: 2500)
        mapView.addAnnotation(annotation)
        mapView.setRegion(region, animated: true)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Save Restaurant Details to CoreData
    
    func saveDataFor(favorite: Restaurant) {
        let restaurant = Restaurant(context: dataController.viewContext)
        restaurant.name = favorite.name
        restaurant.category = favorite.category
        restaurant.latitude = favorite.latitude
        restaurant.longitude = favorite.longitude
        restaurant.rating = favorite.rating
        restaurant.reviewCount = "\(String(describing: favorite.reviewCount)) Reviews"
        restaurant.date = Date()
        restaurant.isFavorite = false
        if let winnerImage = restaurantImageView.image {
            let imageData = winnerImage.jpegData(compressionQuality: 0.8)
            restaurant.image = imageData
        }
        if favoritesFilterSelected != nil {
            restaurant.withFilter = "Selected with \(String(describing: favoritesFilterSelected?.name))"
        }
        dataController.saveViewContext()
    }
    
    func saveDataFor(winner: Business) {
        let restaurant = Restaurant(context: dataController.viewContext)
        restaurant.name = winner.name
        restaurant.category = winner.categories.first?.title
        restaurant.latitude = winner.coordinates.latitude
        restaurant.longitude = winner.coordinates.longitude
        restaurant.rating = winner.rating
        restaurant.reviewCount = "\(String(describing: winner.reviewCount)) Reviews"
        restaurant.date = Date()
        restaurant.isFavorite = false
        if let winnerImage = restaurantImageView.image {
            let imageData = winnerImage.jpegData(compressionQuality: 0.8)
            restaurant.image = imageData
        }
        if let defaultFilterSelected = defaultFilterSelected {
            restaurant.withFilter = "Selected with \(defaultFilterSelected.name)"
        } else if let createdFilterSelected = createdFilterSelected {
            restaurant.withFilter = "Selected with \(createdFilterSelected.name!)"
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
