//
//  PhotoTableViewCell.swift
//  Journal_App
//
//  Created by Samantha Cannillo on 4/18/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var cellImageView: UIImageView!
    @IBOutlet var cellTags: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
