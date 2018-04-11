//
//  Page2ViewController.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import AVFoundation

class Page2ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    // MARK: - Outlets
    @IBOutlet var imageToAnimate: UIImageView!
    @IBOutlet var storyLabel: UILabel!
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var soundButton: UIButton!
    
    // MARK: - Properties
    let synthesizer = AVSpeechSynthesizer()
    var animator: UIViewPropertyAnimator!
    var spokenTextLengths = 0
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Move Corny along the path left or right depending on her last location
        if imageToAnimate.center.x == self.view.frame.width - imageToAnimate.frame.width {
            AnimationFactory.moveLeft(imageView: self.imageToAnimate, view: self.view).startAnimation()
        } else {
            AnimationFactory.moveRight(imageView: self.imageToAnimate, view: self.view).startAnimation()
        }
        
        // Checks User Defaults to see if preference set for Auto Read on or off
        checkSpeakPreferences()
        
        // Store most recently viewed page index to UserDefaults
        defaults.set(1, forKey: "LastVCIndex")
        print("Index of most recent page: 1")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Stop speach if a new page is turned to
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    // MARK: - Actions
    
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "2unwindToHome", sender: self)
    }
    
    @IBAction func soundPressed(_ sender: UIButton) {
        readIt()
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
        homeButton.alpha = 0.5
        soundButton.alpha = 0.5
    }
    
    func enableTouches() {
        homeButton.isUserInteractionEnabled = true
        soundButton.isUserInteractionEnabled = true
        homeButton.alpha = 1.0
        soundButton.alpha = 1.0
    }
    
}
