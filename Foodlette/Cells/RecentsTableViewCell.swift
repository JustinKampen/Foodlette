//
//  RecentsTableViewCell.swift
//  Foodlette
//
//  Created by Justin on 6/28/19.
//  Copyright © 2019 Justin Kampen. All rights reserved.
//

import UIKit

class RecentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recentNameLabel: UILabel!
    @IBOutlet weak var recentFilterSelectedLabel: UILabel!
    @IBOutlet weak var recentDateLabel: UILabel!
    @IBOutlet weak var recentImageView: UIImageView!
    @IBOutlet weak var isFavoriteButton: UIButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
