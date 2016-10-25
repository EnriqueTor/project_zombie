//
//  HUDLayer.swift
//  project_zombie
//
//  Created by Benjamin Su on 10/17/16.
//  Copyright © 2016 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit



class HUDLayer: SKNode {
    
    let healthLabel = SKLabelNode()
    let messageLabel = SKLabelNode()
    
    let ammoLabel = SKLabelNode()
    let useWeapon = SKSpriteNode()
    
    let screenColorEffects = SKSpriteNode()
    
    
    
    
    func updateHUDLayer(playerHealth: Int) {
        
        if healthLabel.text != "Health: \(playerHealth)" {
            healthLabel.text = "Health: \(playerHealth)"
            
            if playerHealth <= 0 {
                
                defeatedScreenAction()
                
                defeatedLabelAction()
                
            } else {
                
                damagedScreenAction()
                
            }
            
        }
        
    }
    
}


// MARK: - Animations and actions
extension HUDLayer {
    
    func damagedScreenAction() {
        
        let fadeIn = SKAction.fadeAlpha(to: 0.2, duration: 0.2)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 0.2)
        let sequence = SKAction.sequence([fadeIn, fadeOut])
        screenColorEffects.run(sequence)
        
    }
    
    func defeatedScreenAction() {
        
        let fadeIn = SKAction.fadeAlpha(to: 0.9, duration: 0.2)
        let blackOut = SKAction.colorize(with: UIColor.black, colorBlendFactor: 1.0, duration: 0.2)
        let sequence = SKAction.sequence([fadeIn, blackOut])
        screenColorEffects.run(sequence)
        
    }
    
    func defeatedLabelAction() {
        
        messageLabel.isHidden = false
        messageLabel.text = "Defeated"
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.3)
        messageLabel.run(fadeIn)
        
    }
    
}



// Load all properties
extension HUDLayer {
    
    func loadHUDLayer() {
        
        self.addChild(healthLabel)
        self.addChild(messageLabel)
        self.addChild(ammoLabel)
        self.addChild(useWeapon)
        
        self.addChild(screenColorEffects)
        
        loadHealthLabel()
        loadMessageLabel()
        loadAmmoLabel()
        loadUseWeapon()
        loadScreenColorEffects()
        
    }
    
    func loadHealthLabel() {
        healthLabel.text = "Health: 0"
        healthLabel.name = "healthLabel"
        healthLabel.fontColor = UIColor.red
        
        healthLabel.position.x = UIScreen.main.bounds.width * -0.55
        healthLabel.position.y = UIScreen.main.bounds.height * 0.55

    }
    
    func loadMessageLabel() {
        messageLabel.alpha = 0.0
        messageLabel.isHidden = true
        messageLabel.fontColor = UIColor.white
        messageLabel.name = "messageLabel"
    }
    
    func loadAmmoLabel() {
        ammoLabel.text = "Bullets: 0"
        ammoLabel.name = "ammoLabel"
        ammoLabel.fontColor = UIColor.yellow
        ammoLabel.position.x = UIScreen.main.bounds.width * -0.55
        ammoLabel.position.y = UIScreen.main.bounds.height * -0.5
    }
    
    func loadUseWeapon() {
        let buttonWidth = UIScreen.main.bounds.size.width * 0.1
        let buttonHeight = UIScreen.main.bounds.size.height * 0.1
        useWeapon.position.x = UIScreen.main.bounds.width * -0.55
        useWeapon.position.y = UIScreen.main.bounds.height * -0.58
        useWeapon.size = CGSize(width: buttonWidth, height: buttonHeight)
        useWeapon.name = "useWeapon"
        useWeapon.color = UIColor.blue
    }
    
    func loadScreenColorEffects() {
     
        let viewWidth = UIScreen.main.bounds.size.width * 1.5
        let viewHeight = UIScreen.main.bounds.size.height * 1.5
        
        screenColorEffects.color = UIColor.red
        screenColorEffects.alpha = 0.0
        screenColorEffects.size = CGSize(width: viewWidth, height: viewHeight)
        screenColorEffects.name = "screenColorEffects"
        
    }
    
}




