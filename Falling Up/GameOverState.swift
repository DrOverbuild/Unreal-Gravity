//
//  GameOverState.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/20/16.
//  Copyright © 2016 Jasper Reddin. All rights reserved.
//

import UIKit
import GameplayKit
import GameKit

class GameOverState: FallingUpGameState {

	let gameOverScale = CGFloat(200) / CGFloat(640)
	
	var gameOver: SKSpriteNode!
	
	override var gui: [SKSpriteNode] {
		get {
			return [gameOver]
		}
	}
	
	override init(game: GameScene) {
		super.init(game: game)
		
		gameOver = SKSpriteNode(imageNamed: "game_over")
		let gameOverScaleFactor = self.game.frame.height * gameOverScale / gameOver.frame.height
		gameOver.setScale(gameOverScaleFactor)
		gameOver.zPosition = 4
		game.addChild(gameOver)
		
		gameOver.position = CGPoint(x: game.midX, y: game.midY - game.frame.height + 5)
	}
	
	override func didEnter(from previousState: GKState?) {
		// TODO: Set up Game Over GUI
		game.character.removeAction(forKey: "Run")
		game.character.removeAction(forKey: "flip")
		
		let texture = SKTexture(imageNamed: "fell")
		game.character.texture = texture
		let scale = CGSize(width: texture.size().width * game.characterHeigt / texture.size().height, height: game.characterHeigt * game.characterUpright)
		game.character.scale(to: scale)
		let angle = (CGFloat.pi / CGFloat(2)) * -game.characterUpright
		game.character.run(SKAction.rotate(byAngle: angle, duration: 0.2))
		
		gameOver.run(SKAction.move(by: CGVector.init(dx: 0, dy: game.frame.height), duration: MainMenuState.transitionDuration))
		
		if game.newBest {
			if GKLocalPlayer.localPlayer().isAuthenticated {
				game.gcManager.reportScore()
			}
			game.newBest = false
		}
	}
	
	override func willExit(to nextState: GKState) {
		// TODO: Remove Game Over GUI
	}
	
	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass is MainMenuState.Type
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		game.gameObjectFactory.update()
	}
	
	override func touchDown(nodes: [SKNode]) {
		game.gameState.enter(MainMenuState.self)
	}
}
