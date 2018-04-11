//
//  AnimationFactory.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/5/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation
import UIKit

// Attribution: - https://www.youtube.com/watch?v=OYLBUvaiWXY&t=257s
class AnimationFactory {
    
    static func scaleUp(imageView: UIImageView) -> UIViewPropertyAnimator {
        
        // Create animator object
        let scale = UIViewPropertyAnimator(
            duration: 0.5,
            curve: .easeIn
        )
        
        // Add animations
        scale.addAnimations {
            imageView.alpha = 1.0
            imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        // Return animator
        return scale
    }
    
    static func moveRight(imageView: UIImageView, view: UIView) -> UIViewPropertyAnimator {
        
        // Create animator object
        let scale = UIViewPropertyAnimator(duration: 2.0, curve: .easeInOut) {
            imageView.center.x = view.frame.width - imageView.frame.width
        }
        
        // Add animations
        scale.addAnimations {
            imageView.alpha = 1.0
            imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        // Return animator
        return scale
    }
    
    static func moveLeft(imageView: UIImageView, view: UIView) -> UIViewPropertyAnimator {
        
        // Create animator object
        let scale = UIViewPropertyAnimator(duration: 2.0, curve: .easeInOut) {
            imageView.center.x = imageView.frame.width
        }
        
        // Add animations
        scale.addAnimations {
            imageView.alpha = 1.0
            imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        // Return animator
        return scale
    }
    
}
