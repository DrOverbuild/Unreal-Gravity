//
//  RandomManager.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/28/16.
//  Copyright © 2016-2017 Jasper Reddin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class RandomManager: NSObject {

	let boolGenerator = GKRandomDistribution(lowestValue: 1, highestValue: 2)
	let numberOfBoxesGenerator: GKGaussianDistribution
	let misalignmentGenerator: GKGaussianDistribution
	let misalignmentAdjustingAmount: CGFloat
	
	init(maxBoxes: Int, boxWidth: CGFloat) {
		numberOfBoxesGenerator = GKGaussianDistribution(lowestValue: 2, highestValue: maxBoxes)
		let highestValue = Int(boxWidth / 2)
		misalignmentGenerator = GKGaussianDistribution(lowestValue: 0, highestValue: highestValue)
		misalignmentAdjustingAmount = CGFloat(highestValue / 2)
	}
	
	func randomGravityMask() -> UInt32{
		return UInt32(boolGenerator.nextInt())
	}
	
	func randomBool() -> Bool {
		return boolGenerator.nextBool()
	}
	
	func randomNumberOfBoxes() -> Int {
		return numberOfBoxesGenerator.nextInt()
	}
	
	func randomMisalignmentAmount() -> CGFloat {
		return CGFloat(misalignmentGenerator.nextInt()) - CGFloat(misalignmentAdjustingAmount)
	}
	
}
