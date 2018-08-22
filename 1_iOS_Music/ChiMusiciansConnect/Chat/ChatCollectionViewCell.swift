//
//  ChatCollectionViewCell.swift
//  ChiMusiciansConnect
//
//  Created by Samantha Cannillo on 5/7/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit

// Create custom chat bubble
// Attribution: - https://www.youtube.com/watch?v=azFjJZxZP6M&list=PL0dzCUj1L5JEfHqwjBV0XFb9qx9cGXwkq&index=11

class ChatCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // Create reference to left side of bubble view
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    // Adding a text view to collection view cell
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "TESTER"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        //tv.numberOfLines = 1000
        
        // text view has background color of white. make it clear to see our subview
        tv.backgroundColor = UIColor.clear
        tv.textColor = UIColor.white
        return tv
    }()
    
    // Create bubble view to hold text
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // Create rounded effect
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    // Hold the width of the bubble view
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        settupMessageBubble()
    }
    
    func settupMessageBubble() {
        addSubview(bubbleView)
        addSubview(textView)
        
        // Cell constraints
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        // Bubble constraints
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
