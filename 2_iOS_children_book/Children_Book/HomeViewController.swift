//
//  HomeViewController.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Properties
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Save to User Defaults a value of 100, indicating that our last page was NOT a book page.
        defaults.set(100, forKey: "LastVCIndex")
        print("Navigated to home screen. UserDefault set to 100.")
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
    }

}
