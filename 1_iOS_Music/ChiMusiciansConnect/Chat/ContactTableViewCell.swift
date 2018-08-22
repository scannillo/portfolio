//
//  ContactTableViewCell.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/2/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

// Custom table view cell for contacts
class ContactTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var name: UILabel!
    @IBOutlet var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
