//
//  AudioPlayer.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/20/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import Foundation
import AVFoundation


extension AVAudioPlayer{
    static func playSound(fileName:String, type:String="wav") ->AVAudioPlayer? {
        var player:AVAudioPlayer? = nil
        let audioPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "wav")
        
        do {
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath!))
            if UserSettings.sharedInstance.sound {
                player!.play()
            }
        }
        catch { }
        
        return player
    }
}

