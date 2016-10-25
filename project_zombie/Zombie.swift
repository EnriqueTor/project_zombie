//
//  Zombie.swift
//  project-zombie
//
//  Created by Benjamin Su on 10/13/16.
//  Copyright © 2016 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Zombie: SKSpriteNode {
    
    var newPosition: CGPoint?
    var moveSpeed: CGFloat = 30
    
    var animationState: AnimationState = .idle
    
    var attackTimer: Double = 0.0
    
    var contactedPlayer: Player?
    
    var zombieWalkTextures: [SKTexture] = []
    var zombieIdleTextures: [SKTexture] = []
    var zombieAttackTextures: [SKTexture] = []
    var walkAnimate = SKAction()
    var idleAnimate = SKAction()
    var attackAnimate = SKAction()
    
    func prepareZombie(textures walk: [SKTexture], idle: [SKTexture], att: [SKTexture]) {
        zombieWalkTextures = walk
        zombieIdleTextures = idle
        zombieAttackTextures = att
        walkAnimate = SKAction.animate(with: zombieWalkTextures, timePerFrame: 0.15)
        idleAnimate = SKAction.animate(with: zombieIdleTextures, timePerFrame: 0.15)
        attackAnimate = SKAction.animate(with: zombieAttackTextures, timePerFrame: 0.15)
    }
    
    func updateTimer(time: Double) {
        
        moveTo(time: time)
        
        if let player = contactedPlayer {
            
            animationState = .attacking
            
            attackTimer += time
            
            if attackTimer >= 0.7 && self.texture == zombieAttackTextures[6] {
                
                player.takeDamage(amount: 1)
                
                attackTimer = 0.0
                
            }
            
        } else {
            attackTimer = 0.0
        }
        
        runAnimationState()
        
    }
    
    func moveTo(time: Double) {
        
        if let pos = newPosition {
            
            let x = pos.x - self.position.x
            let y = pos.y - self.position.y
            
            let distance = sqrt((x * x) + (y * y))
            
            let moveXBy = x / distance * moveSpeed * CGFloat(time)
            let moveYBy = y / distance * moveSpeed * CGFloat(time)
            
            let moveDistance = sqrt((moveXBy * moveXBy) + (moveYBy * moveYBy))
            
            self.setRotation(x: x, y: y)
            
            if moveDistance < distance {
                self.position.x += moveXBy
                self.position.y += moveYBy
                self.animationState = .walking
            } else {
                self.position = pos
                newPosition = nil
                self.animationState = .idle
            }
        }
    }
    
    func setRotation(x: CGFloat, y: CGFloat) {
        var rads = atan2(y, x)
        
        rads = rads < 0 ? abs(rads) : CGFloat(2 * M_PI) - rads
        
        self.zRotation = -rads
        
    }
    
    func runAnimationState() {
        switch animationState {
        case .walking:
            if (self.action(forKey: "walking") == nil) {
                self.removeAllActions()
                self.run(walkAnimate, withKey: "walking")
            }
        case .idle:
            if (self.action(forKey: "idling") == nil) {
                self.removeAllActions()
                self.run(idleAnimate, withKey: "idling")
            }
        case .attacking:
            if (self.action(forKey: "attacking") == nil) {
                self.removeAllActions()
                self.run(attackAnimate, withKey: "attacking")
            }
        }
    }
    
    func detectingPlayer(player: Player) {
        
        let pPos = player.position
        
        let x = pPos.x - self.position.x
        let y = pPos.y - self.position.y
        
        let distance = sqrt((x * x) + (y * y))
        
        if distance < 225 {
            newPosition = pPos
        }
    }
    
    
    
}













