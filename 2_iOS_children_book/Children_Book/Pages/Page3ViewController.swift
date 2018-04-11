//
//  Page3ViewController.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import AVFoundation

class Page3ViewController: UIViewController, AVSpeechSynthesizerDelegate {

    // MARK: - Outlets
    @IBOutlet var cornyImage: UIImageView!
    @IBOutlet var storyLabel: UILabel!
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var soundButton: UIButton!
    @IBOutlet var hauntedHouseView: UIView!
    @IBOutlet var happyCorny: UIImageView!
    @IBOutlet var soundEffectButton: UIButton!
    
    // MARK: - Properties
    let synthesizer = AVSpeechSynthesizer()
    var spokenTextLengths = 0
    var ghostImageView: UIImageView!
    var gravity: UIGravityBehavior!
    var animator: UIDynamicAnimator!
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        happyCorny.alpha = 0.0
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Stop speach & sound effects if a new page is turned to
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        SoundEffects.sharedInstance.stopGhost()
        
        // Put gesture image back
        resetGestureImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Checks User Defaults to see if preference set for Auto Read on or off
        checkSpeakPreferences()
        
        // Store most recently viewed page index to UserDefaults
        defaults.set(2, forKey: "LastVCIndex")
        print("Index of most recent page: 2")
    }
    
    // MARK: - Actions

    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "3unwindToHome", sender: self)
    }
    
    @IBAction func soundEffectPressed(_ sender: UIButton) {
        SoundEffects.sharedInstance.playGhost()
        dropGhost()
    }
        
    @IBAction func soundPressed(_ sender: UIButton) {
        SoundEffects.sharedInstance.stopGhost()
        readIt()
    }
    
    func dropGhost() {
        // Chose a random x position to drop ghost from on screen
        let randomX = arc4random_uniform(UInt32(view.frame.maxX))
        
        // Configure ghost image off screen
        ghostImageView = UIImageView(frame: CGRect(x: abs(Int(randomX)-100), y: -100, width: 100, height: 100))
        ghostImageView.image = UIImage(named: "flyingGhost")
        view.addSubview(ghostImageView)
        
        // Drop ghost image
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: [ghostImageView])
        animator.addBehavior(gravity)
    }

    // MARK: Gesture Recognizing
    
    // Attribution - https://www.raywenderlich.com/162745/uigesturerecognizer-tutorial-getting-started
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        
        // Check for when image ended
        if recognizer.state == .ended {
            checkIntersect(point: (recognizer.view?.center)!)
            print("Image ended")
            checkIntersect(point: (recognizer.view?.center)!)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }

    func checkIntersect(point: CGPoint) {
        if hauntedHouseView.frame.contains(point) == true {
            print("Corny in house")
            happyCorny.alpha = 1.0
            cornyImage.alpha = 0.0
        }
    }
    
    func resetGestureImage() {
        happyCorny.alpha = 0.0
        cornyImage.alpha = 1.0
        cornyImage.frame = CGRect(x: 696, y: 446, width: 126, height: 114)
    }
    
    // MARK: - Speech Synthesizer Methods
    
    // Check UserDefaults to see if user has Auto-Read function set to on or off
    func checkSpeakPreferences() {
        if (UserDefaults.standard.object(forKey: "SwitchPreference") == nil) || (UserDefaults.standard.integer(forKey: "SwitchPreference") == 0) {
            print("Auto read is off. Don't read it automatically!")
            // don't auto read
        } else {
            // auto read
            print("Auto read is on. Read it!")
            readIt()
        }
    }
    
    func readIt() {
        let string = storyLabel.text!
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didStart utterance: AVSpeechUtterance) {
        print("🤖 Start Speaking")
        disableTouches()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        spokenTextLengths = spokenTextLengths + utterance.speechString.utf16.count + 1
        storyLabel.attributedText = NSAttributedString(string: utterance.speechString)
        enableTouches()
    }
    
    // Attribution - https://www.hackingwithswift.com/example-code/media/how-to-highlight-text-to-speech-words-being-read-using-avspeechsynthesizer
    // Attribution - Andrew Binkowski
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           willSpeakRangeOfSpeechString characterRange: NSRange,
                           utterance: AVSpeechUtterance) {
        let start = characterRange.location
        let end = characterRange.length + characterRange.location
        
        print("📣: \(start) - \(end)")
        
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: characterRange)
        storyLabel.attributedText = mutableAttributedString
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("Cancelled speech.")
        enableTouches()
        
        // If page is turned before speach finished reading, set colors back to white
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        let fancyAttributedString = NSMutableAttributedString(string: storyLabel.text!, attributes: attributes)
        storyLabel.attributedText = fancyAttributedString
    }
    
    func disableTouches() {
        homeButton.isUserInteractionEnabled = false
        soundButton.isUserInteractionEnabled = false
        soundEffectButton.isUserInteractionEnabled = false
        soundEffectButton.alpha = 0.5
        homeButton.alpha = 0.5
        soundButton.alpha = 0.5
    }
    
    func enableTouches() {
        homeButton.isUserInteractionEnabled = true
        soundButton.isUserInteractionEnabled = true
        soundEffectButton.isUserInteractionEnabled = true
        soundEffectButton.alpha = 1.0
        homeButton.alpha = 1.0
        soundButton.alpha = 1.0
    }
    
}
