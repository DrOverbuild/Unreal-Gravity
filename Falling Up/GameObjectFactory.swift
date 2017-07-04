//
//  ObjectFactory.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/25/16.
//  Copyright © 2016-2017 Jasper Reddin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameObjectFactory: NSObject {
	
	// Constants
	let game: GameScene
	let maxBoxes: Int
	let initialMinDistanceBetweenStacks: CGFloat
	
	var minDistanceBetweenStacks: CGFloat
	
	let box1Texture = SKTexture(imageNamed: "box_01")
	let box2Texture = SKTexture(imageNamed: "box_02")
	let referenceBoxFrame: CGRect
	let random: RandomManager
//	let labelNode: SKLabelNode
	
//	var minDistanceBetweenStacks: CGFloat {
//		get {
//			// Begin advanced math
//			let height = game.frame.height
//				- (game.worldManager.referenceGrass.frame.height * 2)
//				- game.character.frame.height
//			let time = height.divided(by: 12).squareRoot()
//			let frames = time.multiplied(by: 60)
//			return game.worldManager.worldAcceleration * (frames * frames)
//				+ game.worldManager.grassSpeed
//			// End advance math
//		}
//	}

	var boxes = [Box]()
	var coins = [Coin]()
	
	init(game: GameScene) {
		self.game = game
		
//		labelNode = SKLabelNode(fontNamed: "Arial")
//		labelNode.color = .black
//		labelNode.fontSize = 48
//		labelNode.position = CGPoint(x: 0, y: 0)
//		labelNode.text = "Boxes: 0"
//		game.addChild(labelNode)
		
		referenceBoxFrame = Box(game: game, texture: box1Texture).frame
		
		let stackMaxHeight = game.frame.height
			- (game.worldManager.referenceGrass.frame.height * 2)
			- game.character.frame.height
		
		maxBoxes = Int(stackMaxHeight) / Int(referenceBoxFrame.height)
		
		random = RandomManager(maxBoxes: maxBoxes, boxWidth: referenceBoxFrame.width)
		
		initialMinDistanceBetweenStacks = stackMaxHeight / 1.75
		minDistanceBetweenStacks = initialMinDistanceBetweenStacks
	}
	
	func update(){
		updateBoxes()
		
		minDistanceBetweenStacks += (game.worldManager.worldAcceleration * 20)
	}
	
	func updateBoxes() {
		var boxesToRemove = [Box]()
		
		for box in boxes{
			box.position.x -= game.worldManager.grassSpeed
			
			if !box.passed && box.position.x < game.character.position.x {
				box.passed = true
				if game.gameState.currentState is InGameState {
					game.score += 1
					(game.gameState.currentState as? InGameState)!.updateScore()
				}
			}
			
			if box.position.x + box.frame.width < game.minX {
				boxesToRemove.append(box)
			}
		}
		
		for box in boxesToRemove {
			boxes = boxes.filter({$0 != box})
			box.removeFromParent()
		}
		
		if let lastBox = boxes.last {
			if game.maxX - lastBox.position.x > minDistanceBetweenStacks {
				addNewStack()
			}
		} else {
			addNewStack()
		}
	}
	
	func addNewStack(){
		if !random.randomBool() {
			return
		}
		
		let gravityMask = random.randomGravityMask()
		let numberOfBoxes = random.randomNumberOfBoxes()
		let xPos = game.maxX + referenceBoxFrame.width
		var lastBox: Box?
		
		for _ in 1...numberOfBoxes{
			
			let chosenTexture = (random.randomBool() ? box1Texture : box2Texture)
			
			let newBox = Box(game: game, texture: chosenTexture)
			
			if random.randomBool() {
				newBox.zRotation = CGFloat.pi / 2
			}
			
			newBox.physicsBody?.fieldBitMask = gravityMask
			
			let newXPos = xPos + random.randomMisalignmentAmount()
			
			if lastBox != nil {
				if gravityMask == 1 {
					newBox.position = CGPoint(x: newXPos, y: lastBox!.position.y - (lastBox!.frame.height / 2) - (newBox.frame.height / 2))
				} else {
					newBox.position = CGPoint(x: newXPos, y: lastBox!.position.y + (lastBox!.frame.height / 2) + (newBox.frame.height / 2))
				}
			} else {
				let grass = game.worldManager.referenceGrass
				if gravityMask == 1 {
					newBox.position = CGPoint(x: newXPos, y: game.maxY - grass!.frame.height - (newBox.frame.height / 2))
				} else {
					newBox.position = CGPoint(x: newXPos, y: game.minY + grass!.frame.height + (newBox.frame.height / 2))
				}
			}

			boxes.append(newBox)
			game.addChild(newBox)
			
			lastBox = newBox
		}
	}
	
	/// Clears the objects generated. Called when game is over
	func clear(){
		for box in boxes {
			box.removeFromParent()
		}
		
		boxes = []
		
		for coin in coins {
			coin.removeFromParent()
		}
		
		coins = []
		
		
	}
}
