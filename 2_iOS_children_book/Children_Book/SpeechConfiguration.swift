//
//  SpeechConfiguration.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation
import AVFoundation

// Singleton class to handle organize/handle all networking procedures.
class SpeechConfiguration {
    
    // MARK: - Properties
    static let sharedInstance = SpeechConfiguration()
    
    // Initialization
    private init() {}

    func speakToUs(string: String) {
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.stopSpeaking(at: .word)
        let voice = AVSpeechSynthesisVoice(language: "en_AU")
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = voice
        utterance.pitchMultiplier = 1.0
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
    
}
