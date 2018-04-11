//
//  RootPageViewController.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

class RootPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    // MARK: - Properties
    static let rootPageViewController = RootPageViewController()
    let defaults = UserDefaults.standard
    
    lazy var viewControllerList : [UIViewController] = {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = sb.instantiateViewController(withIdentifier: "page1VC")
        let vc2 = sb.instantiateViewController(withIdentifier: "page2VC")
        let vc3 = sb.instantiateViewController(withIdentifier: "page3VC")
        let vc4 = sb.instantiateViewController(withIdentifier: "page4VC")
        
        return [vc1, vc2, vc3, vc4]

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self

        // Load appropriate first page based on UserDefault preference.
        // 100 signals the app was terminated from a home screen.
        if defaults.integer(forKey: "LastVCIndex") == 100 || defaults.object(forKey: "LastVCIndex") == nil {
            self.setViewControllers([viewControllerList[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        } else if defaults.integer(forKey: "LastVCIndex") == 1 {
            self.setViewControllers([viewControllerList[1]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        } else if defaults.integer(forKey: "LastVCIndex") == 2 {
            self.setViewControllers([viewControllerList[2]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        } else if defaults.integer(forKey: "LastVCIndex") == 3 {
            self.setViewControllers([viewControllerList[3]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        } else {
            self.setViewControllers([viewControllerList[0]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        // Hide the navigation bar when operating within the PageVC
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Turn off tap gestures, only allow page curls
        for recognizer in self.gestureRecognizers {
            if recognizer is UITapGestureRecognizer {
                recognizer.isEnabled = false
            }
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        // Return nil means no VC to display
        guard let currentVCIndex = viewControllerList.index(of: viewController) else {return nil}
        
        // Used to display VC that comes before current VC
        let previousIndex = currentVCIndex - 1
        
        // Make sure previousVC is within range of possible VCs
        guard previousIndex >= 0 else {return nil}
        guard viewControllerList.count > previousIndex else {return nil}
        
        return viewControllerList[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
                
        // Return nil means no VC to display
        guard let currentVCIndex = viewControllerList.index(of: viewController) else {return nil}
        
        // Calculate next indext
        let nextIndex = currentVCIndex + 1
        
        // Make sure nextVC is within range of possible VCs
        guard viewControllerList.count != nextIndex else {return nil}
        guard viewControllerList.count > nextIndex else {return nil}
        
        return viewControllerList[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print("Finished animating to this VC")
    }
}
