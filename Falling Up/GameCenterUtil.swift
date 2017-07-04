//
//  GameCenterUtil.swift
//  Falling Up
//
//  Created by Jasper on 7/4/17.
//  Copyright © 2017 Jasper Reddin. All rights reserved.
//

import UIKit
import GameKit

class GameCenterUtil {

	var game: GameScene
	
	init(withGame game: GameScene) {
		self.game = game
	}
	
	func authenticateGKPlayer() {
		GKLocalPlayer.localPlayer().authenticateHandler = {(viewController : UIViewController?, error : Error?) -> Void in
			if error != nil {
				print(error!.localizedDescription)
			} else if GKLocalPlayer.localPlayer().isAuthenticated {
				self.syncScore()
			}
		}
	}
	
	func reportScore(){
		print("Pushing local score")
		let gkScore = GKScore(leaderboardIdentifier: "grp.ughighscore", player: GKLocalPlayer.localPlayer())
		gkScore.value = game.bestScore
		GKScore.report([gkScore], withCompletionHandler: {(error: Error?) -> Void in
			print("completed.")
			if error != nil {
				print(error!.localizedDescription)
			}
		})
	}
	
	func syncScore() {
		GKLeaderboard.loadLeaderboards(completionHandler: {(leaderboards : [GKLeaderboard]?, error: Error?) -> Void in
			if leaderboards == nil {
				return
			}
			
			print("Leaderboards not nil")
			
			if error != nil {
				return
			}
			
			print("Error not nil")
			
			for leaderboard in leaderboards! {
				if let id = leaderboard.identifier {
					if id == "grp.ughighscore"{
						leaderboard.loadScores(completionHandler: {(scores: [GKScore]?, error2: Error?) -> Void in
							if let score = leaderboard.localPlayerScore { // Should be true if player has played before
								if self.game.bestScore > score.value {
									self.reportScore()
								} else {
									self.game.bestScore = max(self.game.bestScore, score.value)
									self.game.gameState.state(forClass: InGameState.self)!.bestNode.currentValue = Int(self.game.bestScore)
									print("Remote score pulled")
								}
							} else if self.game.bestScore > 0 { // If this is the first time the player has played
								self.reportScore()
							}
						})
						
					}
				}
			}
		})
	}
	
}
