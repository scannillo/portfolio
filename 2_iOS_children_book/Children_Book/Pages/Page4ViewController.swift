//
//  Page4ViewController.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import UIKit
import AVFoundation

class Page4ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    // MARK: - Outlets
    @IBOutlet var homeButton: UIButton!
    @IBOutlet var soundButton: UIButton!
    @IBOutlet var storyLabel: UILabel!
    @IBOutlet var musicButton: UIButton!
    
    // MARK: - Properties
    let synthesizer = AVSpeechSynthesizer()
    var spokenTextLengths = 0
    let defaults = UserDefaults.standard

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // Stop speach if a new page is turned to
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        SoundEffects.sharedInstance.stopMonsterMash()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Checks User Defaults to see if preference set for Auto Read on or off
        checkSpeakPreferences()
        
        // Store most recently viewed page index to UserDefaults
        defaults.set(3, forKey: "LastVCIndex")
        print("Index of most recent page: 3")
    }

    // MARK: - Actions
    
    // Attribution: - https://stackoverflow.com/questions/30052587/how-can-i-go-back-to-the-initial-view-controller-in-swift/30052946
    @IBAction func homePressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "4unwindToHome", sender: self)
    }
    
    @IBAction func soundPressed(_ sender: UIButton) {
        SoundEffects.sharedInstance.stopMonsterMash()
        readIt()
    }
    
    @IBAction func musicPressed(_ sender: UIButton) {
        SoundEffects.sharedInstance.playMonsterMash()
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
        musicButton.isUserInteractionEnabled = false
        musicButton.alpha = 0.5
        homeButton.alpha = 0.5
        soundButton.alpha = 0.5
    }
    
    func enableTouches() {
        homeButton.isUserInteractionEnabled = true
        soundButton.isUserInteractionEnabled = true
        musicButton.isUserInteractionEnabled = true
        musicButton.alpha = 1.0
        homeButton.alpha = 1.0
        soundButton.alpha = 1.0
    }
}
