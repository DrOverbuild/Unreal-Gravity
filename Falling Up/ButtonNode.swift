//
//  ButtonNode.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/20/16.
//  Copyright © 2016 Jasper Reddin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ButtonNode: SKSpriteNode {
	var releasedTexture: SKTexture!
	var pressedTexture: SKTexture!
	var buttonName: String
	var buttonStateMachine: GKStateMachine!
	
	var pressed : Bool {
		get {
			if let state = buttonStateMachine.currentState {
				return state is PressedButtonState
			}
			return false
		}
		
		set (value){
			if value {
				if buttonStateMachine.canEnterState(PressedButtonState.self){
					buttonStateMachine.enter(PressedButtonState.self)
				}
			}else{
				if buttonStateMachine.canEnterState(ReleasedButtonState.self){
					buttonStateMachine.enter(ReleasedButtonState.self)
				}
			}
		}
	}
	
	init(name: String) {
		self.buttonName = name
		releasedTexture = SKTexture(imageNamed: name)
		pressedTexture = SKTexture(imageNamed: name + "_pressed")
		super.init(texture: releasedTexture, color: UIColor.clear, size: releasedTexture.size())
		
		buttonStateMachine = GKStateMachine(states: [ReleasedButtonState(node: self),
		                                             PressedButtonState(node: self)])
		
		self.name = name
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.buttonName = ""
		super.init(coder: aDecoder)
	}
}
