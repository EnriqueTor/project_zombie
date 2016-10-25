//
//  Player.swift
//  project-zombie
//
//  Created by Benjamin Su on 10/13/16.
//  Copyright © 2016 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Player: SKSpriteNode {
    
    var newPosition: CGPoint?
    
    //speed player should move per second
    var moveSpeed: CGFloat = 80
    
    var animationState: AnimationState = .idle
    
    var playerTextures: [SKTexture] = []
    var moveAnimate: SKAction = SKAction()
    
    var health: Int = 10
    
    
    func preparePlayer(textures: [SKTexture]) {
        playerTextures = textures
        moveAnimate = SKAction.animate(with: playerTextures, timePerFrame: 0.15)
     
    }
    
    func takeDamage(amount: Int) {
        health -= amount
    }
    
    func updateTimer(time: Double) {
        
        moveTo(time: time)
        
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
                animationState = .walking
                
            } else {
                
                self.position = pos
                newPosition = nil
                animationState = .idle
                
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
                self.run(moveAnimate, withKey: "walking")
            }
        case .idle:
            if (self.action(forKey: "idling") == nil) {
                self.removeAllActions()
                self.texture = playerTextures[5]
            }
        case .attacking:
            self.removeAllActions()
        }
    }
    
    
}

enum AnimationState {
    case walking
    case idle
    case attacking
}




