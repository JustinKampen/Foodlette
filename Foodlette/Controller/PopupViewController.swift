//
//  PopupViewController.swift
//  Foodlette
//
//  Created by Justin on 9/8/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
    
    // -------------------------------------------------------------------------
    // MARK: - Outlets and Variables
    
    @IBOutlet weak var filterPopupView: UIView!
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var filterNarrativeLabel: UILabel!
    @IBOutlet weak var filterMinRatingLabel: UILabel!
    @IBOutlet weak var filterMaxRatingLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var defaultFilterSelected: DefaultFilter?
    var createdFilterSelected: Filter?
    var foodletteWinner: Business?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    // -------------------------------------------------------------------------
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
//        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        applyRoundStylingFor(filterPopupView)
        applyRoundStylingFor(playButton)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        updatePopupView()
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UI Functionality
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectWinnerFor(filter: Filter) {
        performSegue(withIdentifier: "playFoodlette", sender: nil)
    }
    
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
        } else {
            showAlert(message: "No filter selected")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? WinnerViewController {
            controller.foodletteWinner = foodletteWinner
            controller.defaultFilterSelected = defaultFilterSelected
            controller.createdFilterSelected = createdFilterSelected
            navigationController?.popViewController(animated: true)
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
        return SlideOutAnimationController()
    }
}

// -----------------------------------------------------------------------------
// MARK: - GestureRecognizerDelegate

extension PopupViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === self.view
    }
}
