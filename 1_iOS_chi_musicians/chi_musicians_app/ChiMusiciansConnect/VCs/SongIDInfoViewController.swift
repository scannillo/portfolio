//
//  SongIDInfoViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 3/12/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

//This VC gives instructions for users to find their SongID on soundcloud
class SongIDInfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //Dismiss VC
    @IBAction func gotItPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
