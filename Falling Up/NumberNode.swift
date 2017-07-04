//
//  NumberNode.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/30/16.
//  Copyright © 2016 Jasper Reddin. All rights reserved.
//

import UIKit
import SpriteKit

class NumberNode: SKNode {
	let digitSpacing = CGFloat(0)
	let digits: SKTextureAtlas
	
	var currentValue: Int {
		didSet {
			if currentValue != oldValue {
				updateDigit()
			}
		}
	}
	
	override var frame: CGRect {
		get {
			return self.calculateAccumulatedFrame()
		}
	}
	
	init(digitAtlasNamed digits: SKTextureAtlas) {
		self.digits = digits
		currentValue = 0
		super.init()
		
		updateDigit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		digits = SKTextureAtlas()
		currentValue = 0
		super.init(coder: aDecoder)
	}
	
	func updateDigit(){
		self.removeAllChildren()
		let number = "\(currentValue)"
		var lastDigit: SKSpriteNode?
		
		for digit in number.characters{
			let newDigit = SKSpriteNode(texture: digits.textureNamed("\(digit)"))
			
			if lastDigit == nil {
				newDigit.position = CGPoint(x: newDigit.frame.width / 2, y: 0)
			} else {
				let lastDigitRightEdge = lastDigit!.position.x + lastDigit!.frame.width / 2
				newDigit.position = CGPoint(x: lastDigitRightEdge + digitSpacing + newDigit.frame.width / 2, y: 0)
			}
			
			self.addChild(newDigit)
			lastDigit = newDigit
		}
		
//		let moveBy = self.calculateAccumulatedFrame().width / 2
//		
//		for digit in self.children {
//			digit.position.x -= moveBy
//		}
	}
	
}
