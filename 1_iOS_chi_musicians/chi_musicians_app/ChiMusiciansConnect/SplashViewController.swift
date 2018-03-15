//
//  SplashViewController.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 3/9/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

    var autoDismiss = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Attributions : Andrew Binkowski
    override func viewWillAppear(_ animated: Bool) {
        print("Splash VC will appear.")
        if self.autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                self.dismiss(animated: false, completion: {
                    print("Splash removed.")
                })
            }
        }
    }
}
