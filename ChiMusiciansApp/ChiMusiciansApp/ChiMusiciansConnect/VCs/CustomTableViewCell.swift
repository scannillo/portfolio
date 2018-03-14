//
//  CustomTableViewCell.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 3/3/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

//This class is for custom cells in our MainViewController's table view.
class CustomTableViewCell: UITableViewCell {

    // MARK: Outlets
    @IBOutlet weak var musicianName: UILabel!
    @IBOutlet weak var musicianDetail: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
