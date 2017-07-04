//
//  ShopMenuState.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/20/16.
//  Copyright © 2016-2017 Jasper Reddin. All rights reserved.
//

import UIKit
import GameplayKit

class ShopMenuState: FallingUpGameState {
	var backButton: ButtonNode
	
	let buttonsScale = CGFloat(162) / CGFloat(640)
	
	override var gui: [SKSpriteNode] {
		get {
			return [backButton]
		}
	}
	
	override init(game: GameScene) {
		backButton = ButtonNode(name: "back")
		super.init(game: game)
		
		let backScaleFactor = self.game.frame.height * buttonsScale / backButton.frame.height
		backButton.setScale(backScaleFactor)
		backButton.xScale *= -1
		
		backButton.position = CGPoint(x: game.minX + 40 + backButton.frame.width / 2, y: game.maxY - 40 - backButton.frame.height / 2)
		
		for node in gui {
			node.position.x += game.frame.width
			node.zPosition = 4
			game.addChild(node)
		}
	}
	
	override func didEnter(from previousState: GKState?) {
		// TODO: Set up Shop GUI
	}
	
	override func willExit(to nextState: GKState) {
		// TODO: Remove shop GUI
	}
	
	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass is MainMenuState.Type
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
					if button == backButton {
						game.gameState.enter(MainMenuState.self)
					}
				}
			}
		}
		
		for node in game.children{
			if let button = node as? ButtonNode {
				button.pressed = false
			}
		}
	}
}
