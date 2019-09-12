//
//  FavoriteButton.swift
//  Foodlette
//
//  Created by Justin Kampen on 8/23/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

class FavoriteButton: UIButton {
    
    let dataController = DataController.shared
    let recentViewController = RecentsViewController()
    var isFavorite = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        initButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButton()
    }

    func initButton() {
        addTarget(self, action: #selector(FavoriteButton.buttonPressed), for: .touchUpInside)
    }

    @objc func buttonPressed() {
        activateButton(bool: !isFavorite)
    }

    func activateButton(bool: Bool) {
        let restaurantToUpdate = Restaurant(context: dataController.viewContext)
        isFavorite = bool
//        recentViewController.saveDataForFavorite(cell: <#T##UITableViewCell#>)
        if isFavorite {
            restaurantToUpdate.isFavorite = true
            dataController.saveViewContext()
        } else {
            restaurantToUpdate.isFavorite = false
            dataController.saveViewContext()
        }
        let heartImage = bool ? UIImage(named: "filled-heart-50") : UIImage(named: "open-heart-50")
        setImage(heartImage, for: .normal)
    }
}
