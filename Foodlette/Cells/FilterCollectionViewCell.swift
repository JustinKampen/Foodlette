//
//  FilterCollectionViewCell.swift
//  Foodlette
//
//  Created by Justin on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectionImageView: UIImageView!
    @IBOutlet weak var filterImageView: UIImageView!
    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var filterNarrativeLabel: UILabel!
    
    // -------------------------------------------------------------------------
    // MARK: - Selected Cell Display
    
    var isEditing: Bool = false {
        didSet {
            selectionImageView.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isEditing {
                selectionImageView.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
            }
        }
    }
}
