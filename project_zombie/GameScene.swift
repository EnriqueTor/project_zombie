//
//  GameScene.swift
//  project_zombie
//
//  Created by Benjamin Su on 10/15/16.
//  Copyright © 2016 Benjamin Su. All rights reserved.
//

import SpriteKit
import GameplayKit

//TODO: edit textures
//TODO: set objects in scene programmatically to allow for resets, knowing position of all objects will get great


/*
 randomize nodes
 generate map with nodes
 set escape route
 reusable main label
 menu button
 add weapons?
 redo how camera works? make world move instead of camera?
 */

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var sceneCamera: SKCameraNode!
    
    var player: Player!
    
    var zombies: [Zombie] = []
    
    var isPlaying: Bool = true
    
    var lastFrameTime: TimeInterval = 0.0
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        let playerTexture = [
            SKTexture.init(imageNamed: "walk2"),
            SKTexture.init(imageNamed: "walk3"),
            SKTexture.init(imageNamed: "walk4"),
            SKTexture.init(imageNamed: "walk5"),
            SKTexture.init(imageNamed: "walk6"),
            SKTexture.init(imageNamed: "walk1")]
        
        player = self.childNode(withName: "player") as? Player
        player.preparePlayer(textures: playerTexture)
        
        
        sceneCamera = self.childNode(withName: "sceneCamera") as? SKCameraNode
        
        let interface = HUDLayer()
        interface.loadHUDLayer()
        interface.name = "interface"
        sceneCamera.addChild(interface)
        sceneCamera.position = player.position
        
      
        
        let treeBottomLeft = SKScene(fileNamed: "TreeMapNodes")?.childNode(withName: "TreeNodeBottomLeft")
        treeBottomLeft?.position = CGPoint(x: 300, y: 300)
        treeBottomLeft?.removeFromParent()
        self.addChild(treeBottomLeft!)
        
        let treeBottomRight = SKScene(fileNamed: "TreeMapNodes")?.childNode(withName: "TreeNodeBottomRight")
        treeBottomRight?.position = CGPoint(x: 800 , y: 300)
        treeBottomRight?.removeFromParent()
        self.addChild(treeBottomRight!)
        
        let treeTopLeft = SKScene(fileNamed: "TreeMapNodes")?.childNode(withName: "TreeNodeTopLeft")
        treeTopLeft?.position = CGPoint(x: 300, y: 800)
        treeTopLeft?.removeFromParent()
        self.addChild(treeTopLeft!)
        
        let treeTopRight = SKScene(fileNamed: "TreeMapNodes")?.childNode(withName: "TreeNodeTopRight")
        treeTopRight?.position = CGPoint(x: 800, y: 800)
        treeTopRight?.removeFromParent()
        self.addChild(treeTopRight!)
        
        
        var zombieWalkTexture: [SKTexture] = []
        var zombieIdleTexture: [SKTexture] = []
        var zombieAttackTexture: [SKTexture] = []
        for count in 1...17 {
            zombieWalkTexture.append(SKTexture.init(imageNamed: "zombie_walk\(count)"))
            zombieIdleTexture.append(SKTexture.init(imageNamed: "zombie_idle\(count)"))
        }
        
        for count in 0...8 {
            zombieAttackTexture.append(SKTexture.init(imageNamed: "skeleton-attack_\(count)"))
        }
        
        for count in 1...21 {
            let zombie = (self.childNode(withName: "zombie\(count)") as? Zombie)!
            zombie.prepareZombie(textures: zombieWalkTexture, idle: zombieIdleTexture, att: zombieAttackTexture)
            zombies.append(zombie)
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPlaying {
            if let touch = touches.first {
                let pos = touch.location(in: self)
                player.newPosition = pos
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPlaying {
            if let touch = touches.first {
                let pos = touch.location(in: self)
                player.newPosition = pos
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastFrameTime == 0.0 { lastFrameTime = currentTime }
        
        let frameTime = currentTime - lastFrameTime
        
        if isPlaying {
            
            player.updateTimer(time: frameTime)
            
            for zombie in zombies {
                
                zombie.detectingPlayer(player: player)
                zombie.updateTimer(time: frameTime)
                
            }
            
            sceneCamera.position = player.position
            
            let interface = camera?.childNode(withName: "interface") as? HUDLayer
            
            interface?.updateHUDLayer(playerHealth: player.health)
            
            if player.health <= 0 { isPlaying = false }
            

        }
        
        lastFrameTime = currentTime
        
    }
    
    
    //TODO: reorganize code to allow for scene resets
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        self.didMove(to: self.view!)
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let a = contact.bodyA
        let b = contact.bodyB

        if (a.categoryBitMask == 2) && (b.categoryBitMask == 4) ||
            (a.categoryBitMask == 4) && (b.categoryBitMask == 2) {
            let zBody = a.categoryBitMask == 4 ? a : b
            let pBody = a.categoryBitMask == 2 ? a : b
            for zombie in zombies {
                if zombie == zBody.node as! Zombie {
                    zombie.contactedPlayer = pBody.node as? Player
                }
            }
        }
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
        let a = contact.bodyA
        let b = contact.bodyB
        
        if (a.categoryBitMask == 2) && (b.categoryBitMask == 4) ||
            (a.categoryBitMask == 4) && (b.categoryBitMask == 2) {
            let zBody = a.categoryBitMask == 4 ? a : b
            for zombie in zombies {
                if zombie == zBody.node as! Zombie {
                    
                    zombie.contactedPlayer = nil
                    
                }
            }
        }
    }
    
}







