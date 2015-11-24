//
//  UserSettings.swift
//  CardFlip
//
//  Created by Jordan Doczy on 11/20/15.
//  Copyright © 2015 Jordan Doczy. All rights reserved.
//

import Foundation

class UserSettings{
    static var sharedInstance = UserSettings()
    
    struct Constants{
        static let Sound = "sound"
        static let Difficultry = "difficulty"
    }
    
    enum Difficulty :Int{
        case Easy = 0, Medium, Hard
    }
    
    var sound:Bool{
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(Constants.Sound) as? Bool ?? true
        }
        set{
            NSUserDefaults.standardUserDefaults().setBool(newValue, forKey: Constants.Sound)
        }
    }

    var difficulty:Difficulty{
        get {
            return Difficulty(rawValue:((NSUserDefaults.standardUserDefaults().objectForKey(Constants.Difficultry) as? Int) ?? 0)) ?? Difficulty.Hard
        }
        set{
            NSUserDefaults.standardUserDefaults().setInteger(newValue.rawValue, forKey: Constants.Difficultry)
        }

    }

}