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
        case easy = 0, medium, hard
    }
    
    var sound:Bool{
        get {
            return UserDefaults.standard.object(forKey: Constants.Sound) as? Bool ?? true
        }
        set{
            UserDefaults.standard.set(newValue, forKey: Constants.Sound)
        }
    }

    var difficulty:Difficulty{
        get {
            return Difficulty(rawValue:((UserDefaults.standard.object(forKey: Constants.Difficultry) as? Int) ?? Difficulty.medium.rawValue)) ?? Difficulty.medium
        }
        set{
            UserDefaults.standard.set(newValue.rawValue, forKey: Constants.Difficultry)
        }

    }

}
