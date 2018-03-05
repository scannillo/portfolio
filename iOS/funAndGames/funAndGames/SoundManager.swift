//
//  SoundManager.swift
//  funAndGames
//
//  Created by Samantha Cannillo on 2/6/18.
//  Copyright © 2018 Sammy Cannillo. All rights reserved.
//

import Foundation
import AudioToolbox

class SoundManager {
    
    static let soundInstance = SoundManager()
    
    //Prevent others from default initialization
    fileprivate init() {}

    func playBell() {
        let bellURL = Bundle.main.url(forResource: "open-ended", withExtension: "mp3")!
        
        var bell: SystemSoundID = 0
        
        AudioServicesCreateSystemSoundID(bellURL as CFURL, &bell)
        
        AudioServicesAddSystemSoundCompletion(bell, nil, nil, {
            sound, context in
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
        }, nil)
        
        AudioServicesPlaySystemSound(bell)
    }

    func playHorn() {
        let bellURL = Bundle.main.url(forResource: "hornHonk", withExtension: "mp3")!
        
        var bell: SystemSoundID = 0
        
        AudioServicesCreateSystemSoundID(bellURL as CFURL, &bell)
        
        AudioServicesAddSystemSoundCompletion(bell, nil, nil, {
            sound, context in
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
        }, nil)
        
        AudioServicesPlaySystemSound(bell)
    }
    
    func playCheering() {
        let bellURL = Bundle.main.url(forResource: "cheerSound", withExtension: "mp3")!
        
        var bell: SystemSoundID = 0
        
        AudioServicesCreateSystemSoundID(bellURL as CFURL, &bell)
        
        AudioServicesAddSystemSoundCompletion(bell, nil, nil, {
            sound, context in
            AudioServicesRemoveSystemSoundCompletion(sound)
            AudioServicesDisposeSystemSoundID(sound)
        }, nil)
        
        AudioServicesPlaySystemSound(bell)
    }
    
}


