//
//  ViewController.swift
//  funAndGames
//
//  Created by Samantha Cannillo on 2/3/18.
//  Copyright © 2018 Sammy Cannillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    // MARK: - View Outlets
    @IBOutlet weak var UIView1: UIView!
    @IBOutlet weak var UIView2: UIView!
    @IBOutlet weak var UIView3: UIView!
    @IBOutlet weak var UIView4: UIView!
    @IBOutlet weak var UIView5: UIView!
    @IBOutlet weak var UIView6: UIView!
    @IBOutlet weak var UIView7: UIView!
    @IBOutlet weak var UIView8: UIView!
    @IBOutlet weak var UIView9: UIView!
    
    @IBOutlet weak var informationViewOutlet: InfoView!
    
    // MARK: - Image Outlets
    @IBOutlet weak var xImage: XAndOImageView!
    @IBOutlet weak var oImage: XAndOImageView!
    
    // MARK: - Properties
    var viewsArray = [UIView]()
    var whichPlayerTurn = 1            //Player 1 is X, Player 2 is O
    var oPieceLocations = [Int]()      //Array of UIView.tag of views occupied by O
    var xPieceLocations = [Int]()      //Array of UIView.tag of views occupied by X
    //The tags on the 'placed' pieces will be over 100. Making them easier to remove later
    var placedPiecesTag = 100
    var layer = CAShapeLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        informationViewOutlet.center = CGPoint(x: 188, y: -5000)
        
        viewsArray.append(UIView1)
        viewsArray.append(UIView2)
        viewsArray.append(UIView3)
        viewsArray.append(UIView4)
        viewsArray.append(UIView5)
        viewsArray.append(UIView6)
        viewsArray.append(UIView7)
        viewsArray.append(UIView8)
        viewsArray.append(UIView9)
        
        //Add pan gestures to imageviews
        addPanGestureRecognizerToImage(xImage)
        addPanGestureRecognizerToImage(oImage)
        
        //Establish that it is Player X turn first
        oImage.alpha = 0.3
        oImage.isUserInteractionEnabled = false
    }
    
    // MARK: - UIPanGestureRecognizer
    
    func addPanGestureRecognizerToImage(_ imageView: XAndOImageView) {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        panGesture.delegate = self
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)

        //Check to see if motion of the image ended
        if recognizer.state == .ended {
            checkIntersect(point: (recognizer.view?.center)!)
        }
    }
    
    func checkIntersect(point: CGPoint) {
        var setImage: UIImageView?
        
        var shouldWeHonk = true
        
        if whichPlayerTurn == 1 {
            for eachView in viewsArray {
                if eachView.frame.contains(point) == true {
                    let image = UIImage(named: "redX")
                    setImage = UIImageView(image: image)
                    setImage!.frame = eachView.frame
                    
                    placedPiecesTag += 1
                    setImage?.tag = placedPiecesTag
                    
                    self.view.addSubview(setImage!)
                    shouldWeHonk = false
                    changePlayerTurn()
                    trackXPieceLocation(view: eachView)
                    SoundManager.soundInstance.playBell()
                    
                    if let index = viewsArray.index(of: eachView) {
                        viewsArray.remove(at: index)
                    }
                }
            }
            
            putImageBack()
            
        } else if whichPlayerTurn == 2 {
            for eachView in viewsArray {
                if eachView.frame.contains(point) == true {
                    let image = UIImage(named: "blueO")
                    setImage = UIImageView(image: image)
                    setImage!.frame = eachView.frame
                    
                    placedPiecesTag += 1
                    setImage?.tag = placedPiecesTag
                    
                    self.view.addSubview(setImage!)
                    shouldWeHonk = false
                    changePlayerTurn()
                    trackOPieceLocation(view: eachView)
                    SoundManager.soundInstance.playBell()
                    
                    if let index = viewsArray.index(of: eachView) {
                        viewsArray.remove(at: index)
                    }
                }
            }
            putImageBack()
        }
        
        if shouldWeHonk == true {
            SoundManager.soundInstance.playHorn()
        }
    }
    
    func putImageBack() {
        xImage.frame = CGRect(x: 286, y: 433, width: 65, height: 62)
        oImage.frame = CGRect(x: 21, y: 433, width: 65, height: 62)
    }
    
    // MARK: - Game Lifecycle
    
    func changePlayerTurn() {
        
        if whichPlayerTurn == 1 {
            whichPlayerTurn = 2
            oImage.isUserInteractionEnabled = true
            oImage.alpha = 1.0
            xImage.alpha = 0.3
            xImage.isUserInteractionEnabled = false
            
        } else if whichPlayerTurn == 2 {
            whichPlayerTurn = 1
            xImage.isUserInteractionEnabled = true
            xImage.alpha = 1.0
            oImage.alpha = 0.3
            oImage.isUserInteractionEnabled = false
        }
    }
    
    func trackOPieceLocation(view: UIView) {
        oPieceLocations.append(view.tag)
        checkForWin(tagArray: oPieceLocations)
    }
    
    func trackXPieceLocation(view: UIView) {
        xPieceLocations.append(view.tag)
        checkForWin(tagArray: xPieceLocations)
    }
    
    // - Attributions: https://stackoverflow.com/questions/25714985/how-to-determine-if-one-array-contains-all-elements-of-another-array-in-swift
    func checkForWin(tagArray: [Int]) {
        //Possible winning view.tag arrays
        let possibleWinViews = [[1,2,3],
                                [4,5,6],
                                [7,8,9],
                                [1,4,7],
                                [2,5,8],
                                [3,6,9],
                                [1,5,9],
                                [3,5,7]]
        
        let tagSet = Set(tagArray)
        
        if tagArray.count >= 3 {
            for winCombo in possibleWinViews {
                let winComboSet = Set(winCombo)
                if winComboSet.isSubset(of: tagSet) {
                    SoundManager.soundInstance.playCheering()
                    somebodyWon()
                    drawWinningLine(winCombo: winCombo)
                    return
                }
            }
        }
        if xPieceLocations.count + oPieceLocations.count == 9 {
            nobodyWon()
        }
    }
    
    func somebodyWon() {
        
        var player : String?
        
        if whichPlayerTurn == 1 {
            player = "Player O"
        } else if whichPlayerTurn == 2 {
            player = "Player X"
        }
        
        let alert = UIAlertController(title: "\(player!) Won!", message: "It's been really fun. Play again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            self.resetGame()
        }))
        self.present(alert, animated: true)
    }
    
    func drawWinningLine(winCombo : [Int]) {
        let winViewNumStart = winCombo[0]
        let winViewNumEnd = winCombo[2]
        var startView : UIView
        var endView : UIView

        if winViewNumStart == 1 {
            startView = UIView1
        } else if winViewNumStart == 2 {
            startView = UIView2
        } else if winViewNumStart == 3 {
            startView = UIView3
        } else if winViewNumStart == 4 {
            startView = UIView4
        } else if winViewNumStart == 5 {
            startView = UIView5
        } else if winViewNumStart == 6 {
            startView = UIView6
        } else if winViewNumStart == 7 {
            startView = UIView7
        } else if winViewNumStart == 8 {
            startView = UIView8
        } else {
            startView = UIView9
        }

        if winViewNumEnd == 1 {
            endView = UIView1
        } else if winViewNumEnd == 2 {
            endView = UIView2
        } else if winViewNumEnd == 3 {
            endView = UIView3
        } else if winViewNumEnd == 4 {
            endView = UIView4
        } else if winViewNumEnd == 5 {
            endView = UIView5
        } else if winViewNumEnd == 6 {
            endView = UIView6
        } else if winViewNumEnd == 7 {
            endView = UIView7
        } else if winViewNumEnd == 8 {
            endView = UIView8
        } else {
            endView = UIView9
        }

        let bezierPath = UIBezierPath(rect: CGRect(x: -10, y: -30, width: 10, height: 10))

        bezierPath.move(to: endView.center) //end point
        bezierPath.addLine(to: startView.center)  // start point

        layer = CAShapeLayer()
        layer.path = bezierPath.cgPath
        layer.strokeColor = UIColor.gray.cgColor
        layer.fillColor = UIColor.gray.cgColor
        layer.lineWidth = 5.0

        view.layer.addSublayer(layer)
    }
    
    func nobodyWon() {
        let alert = UIAlertController(title: "Nobody Won.", message: "Sucks. Play again?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
            self.resetGame()
        }))
        self.present(alert, animated: true)
    }
    
    // - Attributions: https://stackoverflow.com/questions/24096908/uiview-viewwithtag-method-in-swift
    func resetGame() {
        //Put functionality back in Player X's hands
        xImage.isUserInteractionEnabled = true
        xImage.alpha = 1.0
        oImage.alpha = 0.3
        oImage.isUserInteractionEnabled = false
        whichPlayerTurn = 1
        oPieceLocations.removeAll()
        xPieceLocations.removeAll()
        
        //Reset game elements
        for i in 100...109 {
            if let imageView = self.view.viewWithTag(i) as? UIImageView {
                UIView.animate(withDuration: 0.9, delay: 0.4, options: UIViewAnimationOptions(), animations: { () -> Void in
                    imageView.center.y = 5000
                }) { (finished) -> Void in
                    imageView.removeFromSuperview()
                }
            }
        }
        
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        
        placedPiecesTag = 100
        
        viewsArray.removeAll()
        viewsArray.append(UIView1)
        viewsArray.append(UIView2)
        viewsArray.append(UIView3)
        viewsArray.append(UIView4)
        viewsArray.append(UIView5)
        viewsArray.append(UIView6)
        viewsArray.append(UIView7)
        viewsArray.append(UIView8)
        viewsArray.append(UIView9)
        
    }
    
    // MARK: - Action for Info Button
    
    // - Attributions: https://stackoverflow.com/questions/9115854/uiview-hide-show-with-animation
    @IBAction func infoButtonPressed(_ sender: UIButton) {
        informationViewOutlet.isHidden = false
        informationViewOutlet.center = CGPoint(x: 188, y: -5000)
        
        var view2 : UIView
        
        view2 = self.informationViewOutlet
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions(), animations: { () -> Void in
            view2.center = CGPoint(x: 188, y: 530)
        }) { (finished) -> Void in
        }
    }
}

//  Image Source: <https://www.flaticon.com/authors/designerz-base>
//                title="Designerz Base"
//                http://creativecommons.org/licenses/by/3.0/

