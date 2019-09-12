//
//  Extensions.swift
//  Foodlette
//
//  Created by Justin Kampen on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIImagePickerController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    static let foodletteBlue = UIColor(red: 0/255, green: 150/255, blue: 255/255, alpha: 1.0)
}


// -----------------------------------------------------------------------------
// MARK: - View Controller Extensions

extension UIViewController {
    
    // -------------------------------------------------------------------------
    // MARK: - Display Alert Message
    // Displays error message/alert to user
    
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // -------------------------------------------------------------------------
    // MARK: - UIView Styling
    // Gives UIViews round appearance
    
    func applyRoundStylingFor(_ view: UIView) {
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
    }
}

