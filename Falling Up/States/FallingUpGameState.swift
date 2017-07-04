//
//  FallingUpGameState.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/19/16.
//  Copyright © 2016-2017 Jasper Reddin. All rights reserved.
//

import UIKit
import GameplayKit

class FallingUpGameState: GKState {
	var game: GameScene
	
	var gui: [SKSpriteNode] {
		get {
			return []
		}
	}
	
	init(game: GameScene){
		self.game = game
	}
	
	func touchDown(nodes: [SKNode]){
		
	}
	
	func touchUp(nodes: [SKNode]){
		
	}
	
	func objectContacted(nodeA: SKNode, nodeB: SKNode){
		
	}
}
