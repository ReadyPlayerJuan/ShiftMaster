//
//  Sounds.swift
//  coolGame
//
//  Created by Nick Seel on 5/5/17.
//  Copyright © 2017 Nick Seel. All rights reserved.
//

import Foundation
import AVFoundation

class Sounds {
    static var viewController: MenuViewController!
    
    static var player: AVAudioPlayer?
    static var loadedSounds = false
    private static var allSounds: [sound] = [//sound(fileName: "shift", fileExtension: "wav", player: nil),
                                             sound(fileName: "shiftIntro", fileExtension: "wav"),
                                             sound(fileName: "shiftLoop", fileExtension: "wav")]
    static let musicSwapBufferTime = 0.0
    static var currentMusicPlaybackMode: musicPlaybackMode = musicPlaybackMode.notPlaying
    static var currentMusic: [sound] = []
    
    enum musicPlaybackMode {
        case notPlaying
        case intro
        case looping
        case fadingOut
    }
    
    struct sound {
        init(fileName: String, fileExtension: String = "", player: AVAudioPlayer? = nil) {
            self.fileName = fileName
            self.fileExtension = fileExtension
            self.player = player
        }
        
        var fileName = ""
        var fileExtension = ""
        var player: AVAudioPlayer? = nil
    }
    
    static func initSounds() {
        Sounds.loadedSounds = true
        
        for i in 0...allSounds.count-1 {
            print(i, allSounds[i])
            let url = NSURL(fileURLWithPath: Bundle.main.path(forResource: allSounds[i].fileName, ofType: allSounds[i].fileExtension)!)
            
            do {
                player = try AVAudioPlayer(contentsOf: url as URL)
                guard player != nil else { return }
                
                player?.prepareToPlay()
                player?.delegate = viewController
                allSounds[i].player = player!
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        currentMusic = [getSound("shiftIntro"), getSound("shiftLoop")]
        currentMusicPlaybackMode = musicPlaybackMode.notPlaying
        
        //playMusic()
    }
    
    static func playMusic() {
        if(currentMusicPlaybackMode == musicPlaybackMode.notPlaying) {
            currentMusicPlaybackMode = musicPlaybackMode.intro
            currentMusic[0].player?.play()
            
            currentMusic[1].player?.numberOfLoops = -1
            currentMusic[1].player?.play(atTime: currentMusic[1].player!.deviceCurrentTime + currentMusic[0].player!.duration + 0.04)
        }
    }
    
    static func updateMusic() {
        
    }
    
    static func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer) {
        if(player == currentMusic[0].player!) {
            currentMusicPlaybackMode = musicPlaybackMode.looping
        }
    }
    
    static func playSound(_ index: Int) {
        if(index < allSounds.count) {
            playSound(allSounds[index])
        } else {
            print("could not play sound: sound missing")
        }
    }
    
    static func playSound(_ name: String) {
        for i in 0...allSounds.count-1 {
            if(allSounds[i].fileName == name) {
                playSound(allSounds[i])
                return
            }
        }
        print("could not play sound: sound missing")
    }
    
    private static func playSound(_ s: sound) {
        if(s.player != nil) {
            s.player?.play()
        } else {
            print("could not play sound: AVAudioPlayer missing")
        }
    }
    
    static func getSound(_ index: Int) -> sound {
        return allSounds[index]
    }
    
    static func getSound(_ name: String) -> sound {
        for i in 0...allSounds.count-1 {
            if(allSounds[i].fileName == name) {
                return allSounds[i]
            }
        }
        
        print("could not find sound " + name)
        return sound(fileName: "", fileExtension: "")
    }
}
