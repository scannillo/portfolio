//
//  SoundEffects.swift
//  Children_Book
//
//  Created by Samantha Cannillo on 4/4/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

import Foundation
import AVFoundation

class SoundEffects {
    
    static let sharedInstance = SoundEffects()
    var monsterMashSound: AVAudioPlayer?
    var ghostSound: AVAudioPlayer?
    
    fileprivate init() {}
    
    func playGhost() {
        let path = Bundle.main.path(forResource: "haunting.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            ghostSound = try AVAudioPlayer(contentsOf: url)
            ghostSound?.play()
        } catch {
            print("Couldn't load ghost sound.")
        }
    }
    
    func stopGhost() {
        ghostSound?.stop()
    }
    
    func playMonsterMash() {
        let path = Bundle.main.path(forResource: "monsterMash.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            monsterMashSound = try AVAudioPlayer(contentsOf: url)
            monsterMashSound?.play()
        } catch {
            print("Couldn't load song.")
        }
    }
    
    func stopMonsterMash() {
        monsterMashSound?.stop()
    }
    
}
