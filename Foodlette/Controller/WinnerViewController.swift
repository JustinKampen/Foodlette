//
//  WinnerViewController.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/27/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import MapKit

class WinnerViewController: UIViewController {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Properties
    
    @IBOutlet weak var winnerImageView: UIImageView!
    @IBOutlet weak var winnerNameLabel: UILabel!
    @IBOutlet weak var winnerAddressLabel: UILabel!
    @IBOutlet weak var filterSelectedLabel: UILabel!
    @IBOutlet weak var winnerRatingImageView: UIImageView!
    @IBOutlet weak var winnerReviewCountLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var dataController = DataController.shared
    var foodletteWinner: Business?
    var defaultFilterSelected: DefaultFilter?
    var createdFilterSelected: Filter?
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Winner!!"
        mapView.delegate = self
        if let foodletteWinner = foodletteWinner {
            displayInformationFor(winner: foodletteWinner)
            displayPinLocationFor(winner: foodletteWinner)
            saveDataFor(winner: foodletteWinner)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.popViewController(animated: false)
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Display UI Helper Functions
    
    func displayInformationFor(winner: Business) {
        winnerNameLabel.text = winner.name
        winnerRatingImageView.image = winner.ratingImage
        winnerReviewCountLabel.text = "\(String(describing: winner.reviewCount)) Reviews"
        if defaultFilterSelected != nil {
            if let defaultFilterSelected = defaultFilterSelected {
                filterSelectedLabel.text = "Selected with \"\(String(defaultFilterSelected.name))\""
            }
        } else {
            if let userFilterSelected = createdFilterSelected {
                filterSelectedLabel.text = "Selected with \"\(String(userFilterSelected.name!))\""
            }
        }
        if let url = URL(string: winner.imageURL) {
            if let data = try? Data(contentsOf: url) {
                winnerImageView.image = UIImage(data: data)
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
        restaurant.withFilter = filterSelectedLabel.text
        restaurant.date = Date()
        restaurant.rating = winner.rating
        restaurant.reviewCount = "\(String(describing: winner.reviewCount)) Reviews"
        if let winnerImage = winnerImageView.image {
            let imageData = winnerImage.jpegData(compressionQuality: 0.8)
            restaurant.image = imageData
        }
        dataController.saveViewContext()
    }
}

// -----------------------------------------------------------------------------
// MARK: - MapView

extension WinnerViewController: MKMapViewDelegate {
    
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
