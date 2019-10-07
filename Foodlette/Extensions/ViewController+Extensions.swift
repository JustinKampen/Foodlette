//
//  ViewController+Extensions.swift
//  Foodlette
//
//  Created by Justin Kampen on 9/24/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func applyRoundStylingFor(view: UIView) {
        view.layer.cornerRadius = 5.0
        view.layer.masksToBounds = true
    }
    
    func applyRoundStylingFor(button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
        button.layer.masksToBounds = true
    }
}
