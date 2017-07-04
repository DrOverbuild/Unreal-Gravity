//
//  OptionsMenuState.swift
//  Falling Up
//
//  Created by Jasper Reddin on 9/20/16.
//  Copyright © 2016 Jasper Reddin. All rights reserved.
//

import UIKit
import GameplayKit

class OptionsMenuState: FallingUpGameState {

	var backButton: ButtonNode
	
	var musicLabel: SKSpriteNode
	var musicMuteButton: MultiWaySwitchNode
	var musicHalfButton: MultiWaySwitchNode
	var musicFullButton: MultiWaySwitchNode
	
	let musicLabelRightPadding: CGFloat = 15
	
	let backButtonsScale = CGFloat(162) / CGFloat(640)
	let optionsButtonScale = CGFloat(120) / CGFloat(640)
	
	override var gui: [SKSpriteNode] {
		get {
			return [backButton, musicLabel, musicMuteButton, musicHalfButton, musicFullButton]
		}
	}
	
	override init(game: GameScene) {
		backButton = ButtonNode(name: "back")
		musicMuteButton = MultiWaySwitchNode(name: "music_mute", otherTwoOptions: [])
		musicHalfButton = MultiWaySwitchNode(name: "music_half", otherTwoOptions: [])
		musicFullButton = MultiWaySwitchNode(name: "music_full", otherTwoOptions: [])
		musicLabel = SKSpriteNode(imageNamed: "music_label")
		super.init(game: game)
		
		let backScaleFactor = self.game.frame.height * backButtonsScale / backButton.frame.height
		backButton.setScale(backScaleFactor)
		
		let optionsScaleFactor = self.game.frame.height * optionsButtonScale / musicMuteButton.frame.height
		musicMuteButton.setScale(optionsScaleFactor)
		musicHalfButton.setScale(optionsScaleFactor)
		musicFullButton.setScale(optionsScaleFactor)
		musicLabel.setScale(optionsScaleFactor)
		
		backButton.position = CGPoint(x: game.maxX - 40 - backButton.frame.width / 2, y: game.maxY - 40 - backButton.frame.height / 2)
		
		musicMuteButton.otherTwoOptions = [musicFullButton, musicHalfButton]
		musicMuteButton.onPress = {self.onMusicVolumeChanged(option: self.musicMuteButton)}
		musicHalfButton.otherTwoOptions = [musicMuteButton, musicFullButton]
		musicHalfButton.onPress = {self.onMusicVolumeChanged(option: self.musicHalfButton)}
		musicFullButton.otherTwoOptions = [musicMuteButton, musicHalfButton]
		musicFullButton.onPress = {self.onMusicVolumeChanged(option: self.musicFullButton)}
		
		let musicOptionsGroupWidth = musicLabel.frame.width + musicLabelRightPadding + musicMuteButton.frame.width + musicHalfButton.frame.width + musicFullButton.frame.width
		
		musicLabel.position = CGPoint(x: game.midX - musicOptionsGroupWidth/2 + musicLabel.frame.width/2, y: game.midY)
		musicMuteButton.position = CGPoint(x: musicLabel.position.x + musicLabel.frame.width/2 + musicMuteButton.frame.width/2 + musicLabelRightPadding, y: game.midY)
		musicHalfButton.position = CGPoint(x: musicMuteButton.position.x + musicMuteButton.frame.width/2 + musicHalfButton.frame.width/2 - 0, y: game.midY)
		musicFullButton.position = CGPoint(x: musicHalfButton.position.x + musicHalfButton.frame.width/2 + musicFullButton.frame.width/2 - 0, y: game.midY)
		
		for node in gui {
			node.position.x -= game.frame.width
			node.zPosition = 4
			game.addChild(node)
		}
	}
	
	func onMusicVolumeChanged(option: MultiWaySwitchNode){
        if option.name == "music_mute" {
            game.audioPlayer.pause()
            UserDefaults.standard.set(0, forKey: "music")
        } else if option.name == "music_half" {
            if !game.audioPlayer.isPlaying{
                game.audioPlayer.play()
            }
			
			game.audioPlayer.volume = 0.25
			UserDefaults.standard.set(1, forKey: "music")
		} else if option.name == "music_full" {
			if !game.audioPlayer.isPlaying{
				game.audioPlayer.play()
			}
			
			game.audioPlayer.volume = 0.75
			UserDefaults.standard.set(2, forKey: "music")
		}
	}
	
	override func didEnter(from previousState: GKState?) {
		if UserDefaults.standard.integer(forKey: "music") == 0 {
			musicMuteButton.press()
		}
		
		if UserDefaults.standard.integer(forKey: "music") == 1 {
			musicHalfButton.press()
		}
		
		if UserDefaults.standard.integer(forKey: "music") == 2 {
			musicFullButton.press()
		}
	}
	
	override func willExit(to nextState: GKState) {
		// TODO: Remove options GUI
	}
	
	override func isValidNextState(_ stateClass: AnyClass) -> Bool {
		return stateClass is MainMenuState.Type
	}
	
	override func touchDown(nodes: [SKNode]) {
		for node in nodes {
			if let button = node as? MultiWaySwitchNode{
				button.press()
			}else if let button = node as? ButtonNode {
				button.pressed = true
			}
		}
	}
	
	override func touchUp(nodes: [SKNode]) {
		for node in nodes{
			if let _ = node as? MultiWaySwitchNode {
				// Run zero lines of code.
			}else if let button = node as? ButtonNode {
				if button.pressed {
					if button == backButton {
						game.gameState.enter(MainMenuState.self)
					}
				}
			}
		}
		
		for node in game.children{
			if let button = node as? ButtonNode {
				if !(button is MultiWaySwitchNode) {
					button.pressed = false
				}
			}
		}
	}
}
