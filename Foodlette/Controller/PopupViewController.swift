//
//  PopupViewController.swift
//  Foodlette
//
//  Created by Justin on 9/8/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit
import CoreData

class PopupViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var filterPopupView: UIView!
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var filterNarrativeLabel: UILabel!
    @IBOutlet weak var filterMinRatingLabel: UILabel!
    @IBOutlet weak var filterMaxRatingLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    enum AnimationStyle {
        case slide
        case fade
    }
    
    var dismissStyle = AnimationStyle.fade
    var dataController = DataController.shared
    var fetchedResultsController: NSFetchedResultsController<Restaurant>!
    var favorites: [Restaurant]?
    var favoritesFilterSelected: DefaultFilter?
    var defaultFilterSelected: DefaultFilter?
    var createdFilterSelected: Filter?
    var favoriteWinner: Restaurant?
    var foodletteWinner: Business?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Fetching CoreData
    
    fileprivate func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            favorites = fetchedResultsController.fetchedObjects ?? []
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        applyRoundStylingFor(view: filterPopupView)
        applyRoundStylingFor(button: playButton)
        playButton.setGradientBackground(colorOne: Colors.darkRed, colorTwo: Colors.lightRed)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        updatePopupView()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Functionality
    
    @IBAction func close() {
        dismissStyle = .slide
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        selectWinnerFrom(data: YelpModel.data)
        if foodletteWinner != nil {
            performSegue(withIdentifier: "winnerDetail", sender: nil)
        } else {
            showAlert(message: "There was an error selecting the winner. Please try again")
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Display Filter Details
    
    func updatePopupView() {
        if defaultFilterSelected != nil {
            filterNameLabel.text = defaultFilterSelected?.name
            filterImageView.image = defaultFilterSelected?.image
            filterNarrativeLabel.text = defaultFilterSelected?.narrative
            if let minRating = defaultFilterSelected?.minRating,
                let maxRating = defaultFilterSelected?.maxRating {
                    filterMinRatingLabel.text = String("Min Rating: \(minRating)")
                    filterMaxRatingLabel.text = String("Max Rating: \(maxRating)")
            }
        } else if createdFilterSelected != nil {
            filterNameLabel.text = createdFilterSelected?.name
            if let imageData = createdFilterSelected?.image {
                filterImageView?.image = UIImage(data: imageData)
            }
            filterNarrativeLabel.text = createdFilterSelected?.narrative
            if let minRating = createdFilterSelected?.minRating,
                let maxRating = createdFilterSelected?.maxRating {
                filterMinRatingLabel.text = String("Min Rating: \(minRating)")
                filterMaxRatingLabel.text = String("Max Rating: \(maxRating)")
            }
        } else {
            showAlert(message: "No filter selected")
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Select Winner for Filter
    
    func selectWinnerFrom(favorites: [Restaurant]) {
        if favorites.count == 0 {
            showAlert(message: "You currently do not have any favorite restaurants")
        }
        for _ in favorites.indices {
            let winnerSelected = Int.random(in: 0...favorites.count - 1)
            favoriteWinner = favorites[winnerSelected]
            break
        }
    }
    
    func selectWinnerFrom(data: [Business], minRating: Double = 1.0, maxRating: Double = 5.0) {
        for _ in data.indices {
            let winnerSelected = Int.random(in: 0...YelpModel.data.count - 1)
            if data[winnerSelected].rating >= minRating && data[winnerSelected].rating <= maxRating {
                foodletteWinner = data[winnerSelected]
                break
            } else {
                showAlert(message: "No restaurants found near you with \(minRating) to \(maxRating) rating. Please try again with a different filter")
            }
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Perform Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? DetailedViewController {
            if let favoritesFilterSelected = favoritesFilterSelected {
                controller.favoritesFilterSelected = favoritesFilterSelected
                controller.favoriteWinner = favoriteWinner
            } else if let defaultFilterSelected = defaultFilterSelected {
                controller.defaultFilterSelected = defaultFilterSelected
                controller.foodletteWinner = foodletteWinner
            } else if let createdFilterSelected = createdFilterSelected {
                controller.createdFilterSelected = createdFilterSelected
                controller.foodletteWinner = foodletteWinner
            }
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - ViewControllerTransitionDelegate

extension PopupViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissStyle {
        case .slide:
            return SlideOutAnimationController()
        case .fade:
            return FadeOutAnimationController()
        }
    }
}

// -----------------------------------------------------------------------------
// MARK: - GestureRecognizerDelegate

extension PopupViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === self.view
    }
}
