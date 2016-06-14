//
//  Player.swift
//  PingPong
//
//  Created by Daniel Burton on 6/3/16.
//  Copyright © 2016 Daniel Burton. All rights reserved.
//

import UIKit

class Player: NSObject {

    var _rating: Double?
    var _birthday: Date?
    var _numberOfGamesPlayed: Int = 0
    var neverLost = true
    var neverWon = true
    
    var rating: Double {
        get {
            if _rating != nil {
                return _rating!
            }
            switch age {
            case 0..<2:
                return 100
            case 2...26:
                return age * 50
            default:
                return 1300
            }
        }
        set {
            _rating = newValue
        }
    }
    
    var effectiveNumberOfGames: Int {
        if _numberOfGamesPlayed == 0 {
            return 0
        }
        if rating > 2355 {
            return 50
        }
        // magic numbers from USCF

        let nPrime = Int(50.0 / sqrt(0.662 + 0.00000739 * pow(2569.0 - rating, 2)))
        
        return _numberOfGamesPlayed < nPrime ? _numberOfGamesPlayed : nPrime
    }
    
    var age: Double {
        get {
            if _birthday == nil {
                return 27
            } else {
                return Double(daysBetween(_birthday!, d2: Date()))
            }
            
        }
    }
    
    func daysBetween(_ d1: Date, d2: Date) -> Int {
        let unitFlags = Calendar.Unit.day
        let cal = Calendar(calendarIdentifier: Calendar.Identifier.gregorian)
        let comp = cal!.components(unitFlags, from: d1, to: d2, options: .wrapComponents)
        return comp.day!
    }
}
