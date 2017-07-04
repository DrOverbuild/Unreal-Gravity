//
//  GameScene.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/15/16.
//  Copyright © 2016-2017 Jasper Reddin. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameKit
import AVFoundation

class GameScene: SKScene {
	static var sharedInstance: GameScene?
	
	var gameViewController: GameViewController!
	
	var character: SKSpriteNode!
	var characterYScale : CGFloat = 1
	
	var characterUpright : CGFloat {
		get {
			if characterYScale < 0 {
				return -1
			} else {
				return 1
			}
		}
	}
	
	var characterHeigt: CGFloat = 0
	var characterXPos: CGFloat = 0
	var characterInGameSize: CGSize!
	
	var worldManager = WorldManager()
	var gameObjectFactory: GameObjectFactory!
	var gameState : GKStateMachine!
	var gcManager : GameCenterUtil!
	
	var score: Int64 = 0 {
		didSet {
			if score > bestScore {
				bestScore = score
				newBest = true
				UserDefaults.standard.set(bestScore, forKey: "best")
			}
		}
	}
	
	var newBest = false
	var bestScore: Int64 = 0
	var previousTime: TimeInterval = 0
	
	var audioPlayer: AVAudioPlayer!
	
	override func didMove(to view: SKView) {

		GameScene.sharedInstance = self
		
		gcManager = GameCenterUtil(withGame: self)
		gcManager.authenticateGKPlayer()
		
		if let bestScore = UserDefaults.standard.value(forKey: "best") as? Int64 {
			self.bestScore = bestScore
		}
		
		setupMusic()
		
		setupWorld()
		
		gameState = GKStateMachine(states: [MainMenuState(game: self), InGameState(game: self),
		                                    OptionsMenuState(game: self), ShopMenuState(game: self),
		                                    GameOverState(game: self)])
		gameState.enter(MainMenuState.self)
	}
	
	func setupMusic() {
		let soundFileURL = Bundle.main.url(forResource: "music3", withExtension: "mp3")
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: soundFileURL!, fileTypeHint: nil)
		} catch let error as NSError {
			print(error.description)
		}
		audioPlayer.numberOfLoops = -1 //infinite
		audioPlayer.volume = 0.75
		
		if let _ = UserDefaults.standard.object(forKey: "music") {
			UserDefaults.standard.set(2, forKey: "music")
		}
		
		if UserDefaults.standard.integer(forKey: "music") == 1 {
			audioPlayer.volume = 0.5
		} else if UserDefaults.standard.integer(forKey: "music") == 2 {
			audioPlayer.volume = 0.75
		}
		
		if UserDefaults.standard.integer(forKey: "music") > 0{
			audioPlayer.play()
		}
	}
	
	func setupWorld() {
		if let ground = self.childNode(withName: "//ground_bottom") {
			ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size)
			ground.physicsBody!.affectedByGravity = false
			ground.physicsBody!.isDynamic = false
		} else {
			print("Could not find node \"//ground_bottom\"")
		}
		
		if let ground = self.childNode(withName: "//ground_top") {
			ground.physicsBody = SKPhysicsBody(rectangleOf: ground.frame.size)
			ground.physicsBody!.affectedByGravity = false
			ground.physicsBody!.isDynamic = false
		} else {
			print("Could not find node \"//ground_top\"")
		}
		
		self.character = self.childNode(withName: "//character") as? SKSpriteNode
		character.zPosition = 1
		character.position.x = minX + (self.frame.width / 4)
		characterXPos = character.position.x
		character.physicsBody = SKPhysicsBody(texture: character.texture!, alphaThreshold: 0.5, size: character.frame.size)
		character.physicsBody!.allowsRotation = false
		character.physicsBody!.fieldBitMask = 2
		character.physicsBody!.mass = 100
		characterInGameSize = character.frame.size
		character.run(SKAction.init(named: "Run")!, withKey: "Run")
		character.alpha = 0
		characterHeigt = character.frame.height
		characterYScale = character.yScale
		
		worldManager.load(withScene: self)
		gameObjectFactory = GameObjectFactory(game: self)
		
		let topGravity = SKFieldNode.linearGravityField(withVector: vector_float3(0, 12, 0))
		topGravity.categoryBitMask = 1
		topGravity.position = CGPoint(x: self.frame.midX, y: self.frame.maxY)
		self.addChild(topGravity)
		
		let bottomGravity = SKFieldNode.linearGravityField(withVector: vector_float3(0, -12, 0))
		bottomGravity.categoryBitMask = 2
		topGravity.position = CGPoint(x: self.frame.midX, y: self.frame.minY)
		self.addChild(bottomGravity)
	}
	
    func touchDown(atPoint pos : CGPoint) {
		let nodes = self.nodes(at: pos)
		
		if nodes.count > 0 {
			if let state = gameState.currentState as? FallingUpGameState {
				state.touchDown(nodes: nodes)
			}
		}
    }
    
    func touchMoved(toPoint pos : CGPoint) {
		
    }
    
    func touchUp(atPoint pos : CGPoint) {
		let nodes = self.nodes(at: pos)
		
		if nodes.count > 0 {
			if let state = gameState.currentState as? FallingUpGameState {
				state.touchUp(nodes: nodes)
			}
		}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
	
    override func update(_ currentTime: TimeInterval) {
		let deltaTime = currentTime - previousTime
		
        // Called before each frame is rendered
		worldManager.update()
		gameState.update(deltaTime: deltaTime)
		
		character.position.x = characterXPos
		
		previousTime = 0
    }
}

extension SKNode {
	var minX: CGFloat {
		get {
			return self.frame.minX
		}
	}
	
	var minY: CGFloat {
		get {
			return self.frame.minY
		}
	}
	
	var midX: CGFloat {
		get {
			return self.frame.midX
		}
	}
	
	var midY: CGFloat {
		get {
			return self.frame.midY
		}
	}
	
	var maxX: CGFloat {
		get {
			return self.frame.maxX
		}
	}
	
	var maxY: CGFloat {
		get {
			return self.frame.maxY
		}
	}
}
