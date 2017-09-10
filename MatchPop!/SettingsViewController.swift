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

    // MARK Members
    fileprivate var audioPlayer:AVAudioPlayer?
    @IBOutlet weak var audioSwitch: UISwitch!
    @IBOutlet weak var difficultySelector: UISegmentedControl!
    
    // MARK: IBActions
    @IBAction func audioToggle(_ sender: UISwitch) {
        audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Click)
        UserSettings.sharedInstance.sound = audioSwitch.isOn
    }

    @IBAction func close(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func difficultySelection(_ sender: UISegmentedControl) {
        audioPlayer = AVAudioPlayer.playSound(Assets.Sounds.Click)
        
        if let difficulty = UserSettings.Difficulty(rawValue: difficultySelector.selectedSegmentIndex) {
            UserSettings.sharedInstance.difficulty = difficulty
        }
    }

    @IBAction func linkToFreepik(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: "http://www.freepik.com/free-vector/animals-flat-vector-set_715458.htm")!)
    }

    // MARK: View Controller Lifecycle
    override func viewDidLoad(){
        super.viewDidLoad()
        audioSwitch.isOn = UserSettings.sharedInstance.sound
        difficultySelector.selectedSegmentIndex = UserSettings.sharedInstance.difficulty.rawValue
    }
}
