//
//  ParentalGateViewController.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/9/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

// Attributions: - Andrew Binkowski for pen drawing functionality
class ParentalGateViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet var drawingImageView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 0.9
    var drawing = false
    var points = [CGPoint]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Draw a line segment
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // Create canvas
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        drawingImageView.image?.draw(in: CGRect(x: 0, y: 0,
                                                width: view.frame.size.width,
                                                height: view.frame.size.height))
        
        // Create line segment
        context!.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context!.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        // Set the pen
        context!.setLineCap(.round)
        context!.setLineWidth(brushWidth)
        context!.setStrokeColor(UIColor.white.cgColor)
        context!.setBlendMode(.normal)
        
        // Stroke path with the pen
        context!.strokePath()
        
        // Copy the canvas to drawingImageView
        drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        drawingImageView.alpha = opacity
        UIGraphicsEndImageContext()
    }
    
    // MARK: - Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Began")
        drawing = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Moved")
        
        drawing = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: view)
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
            points.append(currentPoint)
            print(currentPoint)
        }
    }
    
    // Attribution: - https://www.youtube.com/watch?v=Lrc-MX8WgNc
    override  func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Ended")
        if !drawing {
            drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
        }
        drawingImageView.image = nil
        
        do {
            try checkIfCircle()
            
            // Code below executes when try is successful
            self.dismiss(animated: true, completion: nil)
            print("Passed the parental gate")
            
        } catch DrawingError.tooSmall {
            Alert.showBasic(title: "Try again.", message: "Drawing is too small.", vc: self)
            
        } catch DrawingError.badCircle {
            Alert.showBasic(title: "Try again.", message: "Not a good enough circle shape.", vc: self)
            
        } catch {
            
            // Catch all general case
            Alert.showBasic(title: "Try again.", message: "Drawing not accurate.", vc: self)
        }
    }
    
    // MARK: - Circle Checking
    
    // Check if drawing is close enough to a circle. Throw custom error if not.
    func checkIfCircle() throws {
        let radius = findRadius(arrayOfPoints: points)
        
        // Check circle size. Cannot be smaller than the pumpkin, must be larger.
        if radius < 150.0 {
            print("Circle is not big enough.")
            points.removeAll()
            throw DrawingError.tooSmall
        }
        
        // If circle is large enough, check each point to midpoint
        let center = findCenter(arrayOfPoints: points)
        for point in points {
            if abs(radius - distanceFormula(point1: point, point2: center)) > 35.0 {
                print("Circle is not good enough.")
                points.removeAll()
                throw DrawingError.badCircle
            }
        }
        print("Circle is good enough!")
        points.removeAll()
    }
    
    func findRadius(arrayOfPoints: [CGPoint]) -> Double {
        var maxDistance = 0.0
        for point in points {
            for point2 in points {
                let distance = distanceFormula(point1: point, point2: point2)
                if distance > maxDistance {
                    maxDistance = distance
                }
            }
        }
        return maxDistance/2
    }
    
    func findCenter(arrayOfPoints: [CGPoint]) -> CGPoint {
        var maxDistance = 0.0
        var centerPoint = CGPoint()
        for point in points {
            for point2 in points {
                let distance = distanceFormula(point1: point, point2: point2)
                if distance > maxDistance {
                    maxDistance = distance
                    centerPoint = findMidpoint(point1: point, point2: point2)
                }
            }
        }
        return centerPoint
    }
    
    func distanceFormula(point1: CGPoint, point2: CGPoint) -> Double {
        let distance = sqrt(pow((point2.x-point1.x),2) + pow((point2.y-point1.y),2))
        return Double(distance)
    }
    
    func findMidpoint(point1: CGPoint, point2: CGPoint) -> CGPoint {
        let x = (point1.x + point2.x)/2
        let y = (point1.y + point2.y)/2
        let midpoint = CGPoint(x: x, y: y)
        return midpoint
    }
    
    // MARK: - Actions
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
        self.present(secondViewController, animated: false, completion: nil)
    }
    
}

