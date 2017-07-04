//
//  Box.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/25/16.
//  Copyright © 2016-2017 Jasper Reddin. All rights reserved.
//

import UIKit
import SpriteKit

class Box: SKSpriteNode {
	// Scale Constants
	let boxScale = CGFloat(1) / CGFloat(9)
	
	var passed = false
	var intersected = false
	
	init(game: SKScene, texture: SKTexture) {
		super.init(texture: texture, color: UIColor.clear, size: texture.size())
		
		self.setScale(boxScale * game.frame.height / self.frame.height)
		
		self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
		self.physicsBody?.mass = 1
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
}
