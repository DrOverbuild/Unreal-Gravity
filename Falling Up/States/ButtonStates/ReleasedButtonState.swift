//
//  ReleasedButtonState.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/20/16.
//  Copyright © 2016 Jasper Reddin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ReleasedButtonState: GKState {
	var node: ButtonNode
	
	init(node: ButtonNode) {
		self.node = node
	}
	
	override func didEnter(from previousState: GKState?) {
		node.texture = node.releasedTexture
	}
}
