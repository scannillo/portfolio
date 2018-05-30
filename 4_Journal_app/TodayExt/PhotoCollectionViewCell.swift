//
//  PhotoCollectionViewCell.swift
//  TodayExt
//
//  Created by Samantha Cannillo on 4/27/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet var imageView: UIImageView!
    
    func displayContent(image: UIImage) {
        self.imageView.image = image
    }
}
