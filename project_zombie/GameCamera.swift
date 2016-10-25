//
//  GameCamera.swift
//  project-zombie
//
//  Created by Benjamin Su on 10/13/16.
//  Copyright © 2016 Benjamin Su. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class GameCamera: SKCameraNode {
    
    var cameraScreen: SKNode?
    var healthLabel: SKLabelNode?
    
    func prepareScreen() {
        
        
        
        healthLabel = SKLabelNode(text: "Health: ")
        
        healthLabel?.position = CGPoint(x: self.frame.width * 0.1, y: self.frame.height * 0.1)
        
//        cameraScreen = SKNode()
        
        
    }
    
    
}
