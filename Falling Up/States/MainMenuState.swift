//
//  MainMenuState.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/20/16.
//  Copyright © 2016 Jasper Reddin. All rights reserved.
//

import UIKit
import GameplayKit
import GameKit

class MainMenuState: FallingUpGameState, GKGameCenterControllerDelegate {

	let logoScale = CGFloat(230) / CGFloat(640)
	let buttonsScale = CGFloat(162) / CGFloat(640)
	
	static let transitionDuration: TimeInterval = 0.3
	
	var logo: SKSpriteNode!
	var playButton: ButtonNode!
	var optionsButton: ButtonNode!
	var shopButton: ButtonNode!
	var gcButton: ButtonNode!
	
	override var gui: [SKSpriteNode] {
		get {
			return [logo, playButton, optionsButton, shopButton, gcButton]
		}
	}
	
	override init(game: GameScene) {
		super.init(game: game)
		
		logo = SKSpriteNode(imageNamed: "logo")
		let logoScaleFactor = self.game.frame.height * logoScale / logo.frame.height
		logo.setScale(logoScaleFactor)
		
		playButton = ButtonNode(name: "play_button")
		let playButtonScaleFactor = self.game.frame.height * buttonsScale / playButton.frame.height
		playButton.setScale(playButtonScaleFactor)
		
		optionsButton = ButtonNode(name: "settings")
		let optionsButtonScaleFactor = self.game.frame.height * buttonsScale / optionsButton.frame.height
		optionsButton.setScale(optionsButtonScaleFactor)
		
		shopButton = ButtonNode(name: "shop_button")
		let shopButtonScaleFactor = self.game.frame.height * buttonsScale / shopButton.frame.height
		shopButton.setScale(shopButtonScaleFactor)
		
		gcButton = ButtonNode(name: "gcbutton")
		let gcButtonScaleFactor = self.game.frame.height * buttonsScale / gcButton.frame.height
		gcButton.setScale(gcButtonScaleFactor)
		
		for node in [logo, playButton, optionsButton, shopButton, gcButton] {
			node!.zPosition = 4
			node!.alpha = 1
			game.addChild(node!)
		}
		
		let averageHeight = (logo.frame.height + playButton.frame.height) / 2
		
		let logoPos = CGPoint(x: self.game.midX, y: self.game.midY + averageHeight - logo.frame.height / 2)
		let playButtonPos = CGPoint(x: self.game.midX, y: self.game.midY - averageHeight + playButton.frame.height / 2)
		let optionsButtonPos = CGPoint(x: self.game.midX - playButton.frame.width / 2 - 10 - gcButton.frame.width - 10 - optionsButton.frame.width / 2,
		                               y: playButtonPos.y )
		let gcButtonPos = CGPoint(x: self.game.midX + playButton.frame.width / 2 + 10 + gcButton.frame.width / 2,
		                          y: playButtonPos.y)
		let shopButtonPos = CGPoint(x: gcButtonPos.x + gcButton.frame.width / 2 + 10 + shopButton.frame.width / 2,
		                            y: playButtonPos.y)
		
		logo.position = logoPos
		playButton.position = playButtonPos
		optionsButton.position = optionsButtonPos
		shopButton.position = shopButtonPos
		gcButton.position = gcButtonPos
	}
	
	override func didEnter(from previousState: GKState?) {
		if previousState is OptionsMenuState || previousState is ShopMenuState{
			var startingOffset = game.frame.width
			
			if previousState is OptionsMenuState {
				startingOffset *= -1
			}
			
			var nodes = gui
			nodes.append(contentsOf: (previousState as! FallingUpGameState).gui)
			
			for node in nodes{
				node.run(SKAction.move(by: CGVector(dx: startingOffset, dy: 0), duration: MainMenuState.transitionDuration))
			}
		} else if previousState is GameOverState {
			for node in game.gameObjectFactory.boxes {
				node.run(SKAction.fadeOut(withDuration: MainMenuState.transitionDuration), completion: {
					node.removeFromParent()
					self.game.gameObjectFactory.boxes = self.game.gameObjectFactory.boxes.filter({$0 != node})
				})
			}
			
			game.character.run(SKAction.fadeOut(withDuration: MainMenuState.transitionDuration), completion: {
				let characterUpright = self.game.characterUpright
				
				self.game.character.scale(to: CGSize(width: self.game.characterInGameSize.width, height: self.game.characterInGameSize.height * characterUpright))
				self.game.character.run(SKAction.init(named: "Run")!, withKey: "Run")
				
				let angle = (CGFloat.pi / CGFloat(2)) * characterUpright
				self.game.character.run(SKAction.rotate(byAngle: angle, duration: 0.2))
			})
			
			game.score = 0
			
			var nodes = gui
			nodes.append(contentsOf: (previousState as! FallingUpGameState).gui)
			
			for node in nodes{
				node.run(SKAction.move(by: CGVector(dx: 0, dy: -game.frame.height), duration: MainMenuState.transitionDuration))
			}
		} else{
			logo.run(SKAction.fadeIn(withDuration: MainMenuState.transitionDuration))
			playButton.run(SKAction.fadeIn(withDuration: MainMenuState.transitionDuration))
			optionsButton.run(SKAction.fadeIn(withDuration: MainMenuState.transitionDuration))
			shopButton.run(SKAction.fadeIn(withDuration: MainMenuState.transitionDuration))
		}
	}
	
	override func willExit(to nextState: GKState) {
		var moveBy = CGVector(dx: game.frame.width, dy: CGFloat(0))
		if nextState is ShopMenuState {
			moveBy.dx *= -1
		} else if nextState is InGameState {
			moveBy.dx = 0
			moveBy.dy = game.frame.height
		}
		
		var nodes = gui
		
		if let state = nextState as? FallingUpGameState {
			nodes.append(contentsOf: state.gui)
		}
		
		for node in nodes {
			node.run(SKAction.move(by: moveBy, duration: MainMenuState.transitionDuration))
		}
		
		
	}
	
	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		switch stateClass {
		case is InGameState.Type, is OptionsMenuState.Type, is ShopMenuState.Type:
			return true
		default:
			return false
		}
	}
	
	override func touchDown(nodes: [SKNode]) {
		for node in nodes {
			if let button = node as? ButtonNode {
				button.pressed = true
			}
		}
	}
	
	override func touchUp(nodes: [SKNode]) {
		for node in nodes{
			if let button = node as? ButtonNode {
				if button.pressed {
					if button == optionsButton {
						game.gameState.enter(OptionsMenuState.self)
					}else if button == shopButton {
						game.gameState.enter(ShopMenuState.self)
					}else if button == playButton {
						game.gameState.enter(InGameState.self)
					}else if button == gcButton {
						showLeaderBoard()
					}
				}
			}
		}
		
		for node in game.children{
			if let button = node as? ButtonNode {
				if !(button is MultiWaySwitchNode) {
					button.pressed = false
				}
			}
		}
	}
	
	func showLeaderBoard(){
		if !GKLocalPlayer.localPlayer().isAuthenticated {
			return
		}
		
		let leaderboardVC = GKGameCenterViewController()
		leaderboardVC.gameCenterDelegate = self
		leaderboardVC.leaderboardIdentifier = "grp.ughighscore"
		leaderboardVC.viewState = .leaderboards
		
		game.gameViewController.present(leaderboardVC, animated: true, completion: nil)
	}
	
	func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
		gameCenterViewController.dismiss(animated: true, completion: nil)
	}
}
