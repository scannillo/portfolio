//
//  InfoViewController.swift
//  
//
//  Created by Samantha Cannillo on 3/10/18.
//

import UIKit

//This VC class is the info button describing the apps purpose/functionality
class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Dismiss current VC
    @IBAction func closeInfoButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
