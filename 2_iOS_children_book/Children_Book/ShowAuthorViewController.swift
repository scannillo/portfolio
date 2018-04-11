//
//  ShowAuthorViewController.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/10/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

class ShowAuthorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc = ParentalGateViewController()
        self.present(vc, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }

}
