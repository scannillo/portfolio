//
//  ConversationTableViewCell.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/2/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

// Custom table view cell for message summary
class ConversationTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var recipientName: UILabel!
    @IBOutlet var chatPreview: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
