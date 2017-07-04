//
//  ToggleButtonNode.swift
//  Falling Up
//
//  Created by Jasper Reddin on 4/23/17.
//  Copyright © 2017 Jasper Reddin. All rights reserved.
//

import UIKit

class MultiWaySwitchNode: ButtonNode {
	var otherTwoOptions: [MultiWaySwitchNode]
	var onPress: () -> ()
	
	init(name: String, otherTwoOptions: [MultiWaySwitchNode]) {
		self.otherTwoOptions = otherTwoOptions
		self.onPress = {}
		super.init(name: name)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func press(){
		for option in otherTwoOptions {
			if option.pressed {
				option.pressed = false
			}
		}
		
		self.pressed = true
		self.onPress()
	}
}
