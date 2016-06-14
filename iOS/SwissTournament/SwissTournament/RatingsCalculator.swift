//
//  RatingsCalculator.swift
//  PingPong
//
//  Created by Daniel Burton on 6/3/16.
//  Copyright © 2016 Daniel Burton. All rights reserved.
//

import UIKit

class Game {
    var player1: Player
    var player2: Player
    var score: Double
    
    // score is the result of a game. if player1 won score is 1, if player2 won score is 0, if tie score = 0.5
    init(player1: Player, player2: Player, score: Double) {
        self.player1 = player1
        self.player2 = player2
        self.score = score
    }
    
}

class PlayerResult {
    var player: Player
    var opponents: [Player]
    var score : Double
    
    init(player: Player, score: Double, opponents: [Player]) {
        self.player = player
        self.score = score
        self.opponents = opponents
    }
    
}

class Tournament {
    var playerResults = [PlayerResult]()
    var games = [Game]()
}

class RatingsCalculator: NSObject {

    var tournament : Tournament
    
    init(tournament: Tournament) {
        self.tournament = tournament
    }
    
    func objectiveFunction(_ nPrime: Double, r0Prime: Double, sPrime: Double, result: PlayerResult) -> Double {
        var sumPWe = 0.0
        for opponent in result.opponents {
            sumPWe += provisionalWinningExpectancy(result.player.rating, opponentRating: opponent.rating)
        }
        let pwe = provisionalWinningExpectancy(result.player.rating, opponentRating: r0Prime)
        return nPrime * pwe + sumPWe - sPrime
    }
    
    /*
     Calculate a first rating estimate for each unrated player for whom Step 1 gives N = 0. For these players, use the “special” rating formula (see Section 4.1), letting R0 be the initialized rating. However, for only this step in the computation, set the number of effective games for these players to 1 (this is done to properly “center” the ratings when most or all of the players are previously unrated).
     • If an opponent of the unrated player has a pre-event rating, use this rating in the rating formula.
     • If an opponent of the unrated player is also unrated, then use the initialized rating from Step 1.
     If the resulting rating from Step 3 for the unrated player is less than 100, then change the rating to 100.
     */
    func calculateFirstRatings() {
        for result in tournament.playerResults {
            let r0 = result.player.rating
            let nPrime = Double(result.player.effectiveNumberOfGames)
            let m = Double(result.opponents.count)
            let s = result.score
            let player = result.player
            var r0Prime = r0
            var sPrime = s + nPrime / 2
            if nPrime != 0 {
                if player.neverLost {
                    r0Prime = r0 - 400
                    sPrime = s + nPrime
                } else if player.neverWon {
                    r0Prime = r0 + 400
                    sPrime = s
                }
            }
            let epslion = 0.0000001
            let x0 = r0Prime - 400
            let y0 = r0Prime + 400
            
            let M = (nPrime * r0Prime + knotSum(result.opponents, s: s, m: m)) / (nPrime + m)
        }
        
    }
    
    func knotSum(_ opponents: [Player], s:Double, m: Double) -> Double {
        var result = 0.0
        
        for opponent in opponents {
            result += opponent.rating + 400 * (2 * s - m)
        }
        return result
    }
    
    /*
     For every player, calculate an intermediate rating with the appropriate rating for- mula.
     • If a player’s rating R0 from Step 1 is based upon 8 or fewer games (N ≤ 8), or if a player’s game outcomes in all previous events have been either all wins or all losses, then use the “special” rating formula (see Section 4.1), with “prior” rating R0.
     • If a player’s rating R0 from Step 1 is based upon more than 8 games (N > 8), and has not been either all wins or all losses, use the “standard” rating formula (see Section 4.2). Note that the standard formula is used even if the “effective” number of games from Step 2 is less than or equal to 8.
     In the calculations, use the opponents’ pre-event ratings in the computation (for players with pre-event ratings). For unrated opponents who are assigned N = 0 in Step 1, use the results of Step 3 for their ratings. For unrated opponents who are assigned N > 0 in Step 1, use their assigned rating from Step 1.
     If the resulting rating from Step 4 is less than 100, then change the rating to 100.
     */
    func calculateIntermediateRatings() {
        
    }
    
    /*
     Repeat the calculations from calculateIntermediateRatings for every player, again using a player’s pre- event rating (or the assigned ratings from Step 1 for unrated players) to perform the calculation, but using the results of Step 4 for the opponents’ ratings. If the resulting rating from Step 5 is less than 100, then change the rating to 100.
     */
    func calculateFinalRating() {
    
    }
    
    func provisionalWinningExpectancy (_ playerRating: Double, opponentRating: Double) -> Double {
        if playerRating <= opponentRating - 400 {
            return 0
        }
        if playerRating >= opponentRating + 400 {
            return 1
        }
        return 0.5 + (playerRating - opponentRating) / 800.0
    }
    
    func rateTournament()  {
        calculateFirstRatings()
        calculateIntermediateRatings()
        calculateFinalRating()
    }
    
    
}
