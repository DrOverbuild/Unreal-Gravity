//
//  InGameState.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/20/16.
//  Copyright © 2016-2017 Jasper Reddin. All rights reserved.
//

import UIKit
import GameplayKit

class InGameState: FallingUpGameState {
	var labelScaleFactor = CGFloat(0.155)
	var labelPadding = CGFloat(5)
	
	let numbersAtlas = SKTextureAtlas(named: "numbers")
	
	var scoreNode: NumberNode!
	var bestLabelNode: SKSpriteNode!
	var bestNode: NumberNode!
	
	var boxesHit = 0
	
	var scoreNodePos: CGPoint {
		get {
			return CGPoint(x: game.maxX - scoreNode.frame.width - labelPadding,
			               y: game.maxY - scoreNode.frame.height / 2 - labelPadding)
		}
	}
	
	var bestLabelNodePos: CGPoint {
		get {
			return CGPoint(x: game.minX + (bestLabelNode.frame.width / 2) + labelPadding,
			               y: game.maxY - (bestLabelNode.frame.height / 2) - labelPadding)
		}
	}
	
	var bestNodePos: CGPoint {
		get {
			return CGPoint(x: bestLabelNodePos.x + (bestLabelNode.frame.width / 2),
			               y: bestLabelNodePos.y)
		}
	}
	
	var debugRect: SKShapeNode!
	
	override init(game: GameScene) {
		super.init(game: game)
		
		scoreNode = NumberNode(digitAtlasNamed: numbersAtlas)
		scoreNode.currentValue = 0
		let height = labelScaleFactor * game.frame.height
		labelScaleFactor = height / scoreNode.frame.height
		scoreNode.zPosition = 4
		scoreNode.setScale(labelScaleFactor)
		scoreNode.position = CGPoint(x: game.maxX - scoreNode.frame.width - labelPadding,
		                             y: game.maxY + scoreNode.frame.height / 2 + labelPadding)
		game.addChild(scoreNode)
		
		bestLabelNode = SKSpriteNode(imageNamed: "best")
		bestLabelNode.zPosition = 4
		bestLabelNode.setScale(labelScaleFactor)
		bestLabelNode.position = CGPoint(x: game.minX + bestLabelNode.frame.width / 2 + labelPadding,
		                                 y: game.maxY + bestLabelNode.frame.height / 2 + labelPadding)
		game.addChild(bestLabelNode)
		
		bestNode = NumberNode(digitAtlasNamed: numbersAtlas)
		bestNode.currentValue = Int(game.bestScore)
		bestNode.zPosition = 4
		bestNode.setScale(labelScaleFactor)
		bestNode.position = CGPoint(x: bestLabelNode.position.x + bestLabelNode.frame.width / 2,
		                            y: bestLabelNode.position.y)
		game.addChild(bestNode)
	}
	
	override func didEnter(from previousState: GKState?) {
		// TODO: Start game
		
		game.gameObjectFactory.minDistanceBetweenStacks = game.gameObjectFactory.initialMinDistanceBetweenStacks
		
		game.character.position.y = game.midY
		game.character.run(SKAction.fadeIn(withDuration: 0.3))
		
		scoreNode.run(SKAction.move(to: scoreNodePos, duration: 0.3))
		bestLabelNode.run(SKAction.move(to: bestLabelNodePos, duration: 0.3))
		bestNode.run(SKAction.move(to: bestNodePos, duration: 0.3))
//		scoreNode.run(SKAction.fadeIn(withDuration: 0.3))
	}

	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass is GameOverState.Type
	}
	
	override func touchDown(nodes: [SKNode]) {
		if let character = game.childNode(withName: "//character") as? SKSpriteNode {
			game.characterYScale *= -1
			character.removeAction(forKey: "flip")
			character.run(SKAction.scaleY(to: game.characterYScale, duration: 0.2), withKey: "flip")
			character.physicsBody?.fieldBitMask = (character.physicsBody?.fieldBitMask == 1 ? 2 : 1)
		}
	}
	
	override func update(deltaTime seconds: TimeInterval) {
		game.gameObjectFactory.update()

		if let contactedBodies = game.character.physicsBody?.allContactedBodies() {
			for body in contactedBodies {
				if let node = body.node as? Box{
					if !node.intersected{
						node.intersected = true
						characterHitsBox()
					}
				}
			}
		}
	}
	
	func updateScore() {
		scoreNode.currentValue = Int(game.score)
		scoreNode.run(SKAction.move(to: scoreNodePos, duration: 0.1))
		bestNode.currentValue = Int(game.bestScore)
	}
	
	func characterHitsBox() {
		game.gameState.enter(GameOverState.self)
	}
}
