//
//  SettingsViewController.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/20/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import UIKit
import AVFoundation

class SettingsViewController: UIViewController {

    private var audioPlayer:AVAudioPlayer?

    @IBOutlet weak var audioSwitch: UISwitch!
    @IBOutlet weak var difficultySelector: UISegmentedControl!
    
    @IBAction func linkToFreepik(sender: UIButton) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.freepik.com/free-vector/animals-flat-vector-set_715458.htm")!)
    }
    
    @IBAction func audioToggle(sender: UISwitch) {
        audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Click)
        UserSettings.sharedInstance.sound = audioSwitch.on
    }
    
    @IBAction func difficultySelection(sender: UISegmentedControl) {
        audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Click)
        
        if let difficulty = UserSettings.Difficulty(rawValue: difficultySelector.selectedSegmentIndex) {
            UserSettings.sharedInstance.difficulty = difficulty
        }
    }
    
    @IBAction func close(sender: AnyObject) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        audioSwitch.on = UserSettings.sharedInstance.sound
        difficultySelector.selectedSegmentIndex = UserSettings.sharedInstance.difficulty.rawValue
    }
}
