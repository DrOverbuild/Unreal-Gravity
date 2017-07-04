//
//  GameViewController.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/15/16.
//  Copyright © 2016 Jasper Reddin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
        loadScene()
	}
	
	func loadScene(){
		if let scene = GKScene(fileNamed: "GameScene") {
			if let sceneNode = scene.rootNode as! GameScene? {
				// Set the scale mode to scale to fit the window
				sceneNode.scaleMode = .aspectFill
				sceneNode.gameViewController = self
				
				// Present the scene
				if let view = self.view as! SKView? {
					view.presentScene(sceneNode)
					
					view.ignoresSiblingOrder = true
					
					view.showsFPS = false
					view.showsNodeCount = false
				}
			}
		}
	}

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

	@IBAction func swipeDown(_ sender: AnyObject) {
		if let view = self.view as! SKView? {
			if let game = view.scene as? GameScene {
				if game.gameState.currentState is InGameState {
					view.isPaused = !view.isPaused
				} else if game.gameState.currentState is GameOverState {
					loadScene()
				}
			}
		}
	}
	
	@IBAction func swipeRight(_ sender: Any) {
		if let view = self.view as! SKView? {
			if let game = view.scene as? GameScene {
				if game.gameState.currentState is MainMenuState {
					game.gameState.enter(OptionsMenuState.self)
				} else if game.gameState.currentState is ShopMenuState {
					game.gameState.enter(MainMenuState.self)
				}
			}
		}
	}
	
	@IBAction func swipeLeft(_ sender: Any) {
		if let view = self.view as! SKView? {
			if let game = view.scene as? GameScene {
				if game.gameState.currentState is MainMenuState{
					game.gameState.enter(ShopMenuState.self)
				} else if game.gameState.currentState is OptionsMenuState {
					game.gameState.enter(MainMenuState.self)
				}
			}
		}
	}
	
	@IBAction func swipeUp(_ sender: Any) {
		if let view = self.view as! SKView? {
			if let game = view.scene as? GameScene {
				if game.gameState.currentState is MainMenuState{
					game.gameState.enter(InGameState.self)
				}
			}
		}
	}
	
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
