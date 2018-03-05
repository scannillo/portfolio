//
//  InfoView.swift
//  funAndGames
//
//  Created by Samantha Cannillo on 2/4/18.
//  Copyright © 2018 Sammy Cannillo. All rights reserved.
//

import UIKit

class InfoView: UIView {

    //MARK: Outlets
    @IBOutlet weak var howToPlay: UILabel!
    @IBOutlet weak var instructionsTextView: UITextView!
    
    //MARK: Actions
    @IBAction func startPlayingPressed(_ sender: Any) {
        //self.isHidden = true
        
        UIView.animate(withDuration: 1.0, delay: 0.4, options: UIViewAnimationOptions(), animations: { () -> Void in
            self.center = CGPoint(x: 188, y: 2000)
        }) { (finished) -> Void in
        }
    }
}
