//
//  ShapeView.swift
//  funAndGames
//
//  Created by Samantha Cannillo on 2/7/18.
//  Copyright © 2018 Sammy Cannillo. All rights reserved.
//

import UIKit

class ShapeView: UIView {

    var path: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createLine() {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
    }
    
    override func draw(_ rect: CGRect) {
        self.createLine()
    }
}
