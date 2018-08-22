//
//  ActivityIndicator.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/17/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import Foundation

// Uniform Activity Indicator 
extension UIViewController {
    
    // Attributions: https://github.com/erangaeb/dev-notes/blob/master/swift/ViewControllerUtils.swift
    func showActivityIndicator2(container: UIView, loadingView: UIView, uiView: UIView, actInd: UIActivityIndicatorView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex2(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(origin: .zero, size : CGSize(width: 80, height: 80))
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex2(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRect(origin: .zero, size : CGSize(width: 40, height: 40))
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2,y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }

    func hideActivityIndicator2(container: UIView, uiView: UIView, actInd: UIActivityIndicatorView) {
        actInd.stopAnimating()
        container.removeFromSuperview()
    }

    func UIColorFromHex2(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    // Error in internet/network connectivity
    func badConnectionAlert2() {
        let alert = UIAlertController(title: "Bad Connection", message: "No internet available.", preferredStyle: .alert)
        let okay = UIAlertAction(title: "Okay", style: .destructive, handler: { (action) -> Void in })
        alert.addAction(okay)
        okay.setValue(UIColor.orange, forKey: "titleTextColor")
        self.present(alert, animated: true)
    }
    
}
