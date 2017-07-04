//
//  WorldManager.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/16/16.
//  Copyright © 2016-2017 Jasper Reddin. All rights reserved.
//

import UIKit
import SpriteKit

/// Keeps the side scroller scrolling.
class WorldManager: NSObject {
	
	let initialGrassSpeed = CGFloat(5)
	let worldAcceleration = CGFloat(0.0008)
	let worldDeceleration = CGFloat(0.05)
	
	var grassSpeed = CGFloat(0)
	
	var scene : GameScene!
	
	var grassScale = CGFloat(125) / CGFloat(1080)
	var hillsScale = CGFloat(210) / CGFloat(1080)
	var treesScale = CGFloat(175) / CGFloat(1080)
	
	var topGrassNodes = [SKSpriteNode]()
	var bottomGrassNodes = [SKSpriteNode]()
	var topHillsNodes = [SKSpriteNode]()
	var bottomHillsNodes = [SKSpriteNode]()
	var topTreesNodes = [SKSpriteNode]()
	var bottomTreesNodes = [SKSpriteNode]()
	
	var referenceGrass : SKSpriteNode!
	var referenceHill : SKSpriteNode!
	var referenceTrees : SKSpriteNode!
	
	// MARK -- Load up nodes on first launch
	func load(withScene scene: GameScene) {
		self.scene = scene
		
		referenceGrass = SKSpriteNode(imageNamed: "grass")
		let grassScaleFactor = (scene.frame.height * grassScale) / referenceGrass.frame.height
		referenceGrass.setScale(grassScaleFactor)
		
		loadBottomGrass()
		loadTopGrass()
		
		referenceHill = SKSpriteNode(imageNamed: "hills2")
		let hillsScaleFactor = (scene.frame.height * hillsScale) / referenceHill.frame.height
		referenceHill.setScale(hillsScaleFactor)
		referenceHill.zPosition = -98
		
		loadBottomHills()
		loadTopHills()
		
		referenceTrees = SKSpriteNode(imageNamed: "trees")
		let treesScaleFactor = (scene.frame.height * treesScale) / referenceTrees.frame.height
		referenceTrees.setScale(treesScaleFactor)
		referenceTrees.zPosition = -97
	
		loadTopTrees()
		loadBottomTrees()
	}
	
	func loadBottomGrass(){
		let grass = referenceGrass.copy() as! SKSpriteNode
		grass.position.x = scene.minX + grass.frame.width / 2
		grass.position.y = scene.minY + grass.frame.height / 2
		scene.addChild(grass)
		bottomGrassNodes.append(grass)
		
		while (bottomGrassNodes.last?.position.x)! <= scene.maxX {
			let newGrass = bottomGrassNodes.last?.copy() as! SKSpriteNode
			newGrass.position.x += newGrass.frame.width
			scene.addChild(newGrass)
			bottomGrassNodes.append(newGrass)
		}
	}
	
	func loadTopGrass(){
		let topGrass = referenceGrass.copy() as! SKSpriteNode
		topGrass.zRotation = CGFloat.pi
		topGrass.position.x = scene.minX + topGrass.frame.width / 2
		topGrass.position.y = scene.maxY - topGrass.frame.height / 2
		scene.addChild(topGrass)
		topGrassNodes.append(topGrass)
		
		while (topGrassNodes.last?.position.x)! <= scene.maxX {
			let newGrass = topGrassNodes.last?.copy() as! SKSpriteNode
			newGrass.position.x += newGrass.frame.width
			scene.addChild(newGrass)
			topGrassNodes.append(newGrass)
		}

	}
	
	func loadBottomHills(){
		let hills = referenceHill.copy() as! SKSpriteNode
		let bottomGrassNodeTopEdge = bottomGrassNodes.first!.position.y + bottomGrassNodes.first!.frame.height / 2
		hills.position.x = scene.midX
		hills.position.y = bottomGrassNodeTopEdge + referenceHill.frame.height / 2 - 5
		scene.addChild(hills)
		bottomHillsNodes.append(hills)
	}
	
	func loadTopHills(){
		let hills = referenceHill.copy() as! SKSpriteNode
		hills.zRotation = CGFloat.pi
		let topGrassNodeBottomEdge = topGrassNodes.first!.position.y - referenceGrass.frame.height / 2
		hills.position.x = scene.midX
		hills.position.y = topGrassNodeBottomEdge - referenceHill.frame.height / 2 + 5
		scene.addChild(hills)
		topHillsNodes.append(hills)
	}
	
	func loadBottomTrees(){
		let trees = referenceTrees.copy() as! SKSpriteNode
		let bottomGrassNodeTopEdge = bottomGrassNodes.first!.position.y + bottomGrassNodes.first!.frame.height / 2
		trees.position.x = scene.midX
		trees.position.y = bottomGrassNodeTopEdge + referenceTrees.frame.height / 2
		scene.addChild(trees)
		topTreesNodes.append(trees)
	}
	
	func loadTopTrees(){
		let trees = referenceTrees.copy() as! SKSpriteNode
		trees.zRotation = CGFloat.pi
		let topGrassNodeBottomEdge = topGrassNodes.first!.position.y - referenceGrass.frame.height / 2
		trees.position.x = scene.midX
		trees.position.y = topGrassNodeBottomEdge - referenceTrees.frame.height / 2
		scene.addChild(trees)
		bottomTreesNodes.append(trees)
	}
	
	// MARK -- Handle each frame
	func update(){
//		updateBottomGrass()
//		updateTopGrass()
		updateNodes(&topGrassNodes, forSpeed: grassSpeed)
		updateNodes(&bottomGrassNodes, forSpeed: grassSpeed)
		updateNodes(&bottomHillsNodes, forSpeed: grassSpeed * 0.1)
		updateNodes(&topHillsNodes, forSpeed: grassSpeed * 0.1)
		updateNodes(&bottomTreesNodes, forSpeed: grassSpeed * 0.15)
		updateNodes(&topTreesNodes, forSpeed: grassSpeed * 0.15)
		
		if scene.gameState.currentState is InGameState {
			if grassSpeed < initialGrassSpeed {
				grassSpeed = initialGrassSpeed
			}
			
			grassSpeed += worldAcceleration
		} else if scene.gameState.currentState is GameOverState {
			if grassSpeed > 0 {
				grassSpeed -= worldDeceleration
			} else {
				grassSpeed = 0
			}
		} else {
			if grassSpeed < initialGrassSpeed {
				grassSpeed += worldDeceleration
			} else {
				grassSpeed = initialGrassSpeed
			}
		}
	}
	
	func updateNodes(_ nodes: inout [SKSpriteNode], forSpeed speed: CGFloat){
		for node in nodes {
			node.position.x -= speed;
		}
		
		if nodes.first!.position.x + nodes.first!.frame.width / 2 < scene.minX {
			nodes.first?.removeFromParent()
			nodes.removeFirst()
		}
		
		if nodes.last!.position.x + nodes.last!.frame.width / 2 <= scene.maxX{
			let newNode = nodes.last!.copy() as! SKSpriteNode
			newNode.position.x += newNode.frame.width
			scene.addChild(newNode)
			nodes.append(newNode)
		}
	}
}
