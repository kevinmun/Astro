//
//  StickyCollectionViewCell.swift
//  Astro
//
//  Created by Kevin Mun on 13/06/2017.
//  Copyright © 2017 kevin. All rights reserved.
//

import UIKit

class StickyCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }

}
