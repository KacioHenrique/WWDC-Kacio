//
//  Groundbutton .swift
//  indoComTilemap
//
//  Created by kacio henrique couto batista on 17/03/19.
//  Copyright © 2019 kacio henrique couto batista. All rights reserved.
//

import Foundation
import SpriteKit

public enum TypeGround : String{
    case Water = "Water"
    case Grass = "Grass"
    case Sand = "Sand"
    case Rock = "Rock"
    case Tree = "Tree"
}

public protocol Button {
    func sendType(ground:GroundButton)
}
public class GroundButton:SKSpriteNode{
    public var typeGround:TypeGround
    public var delgate:Button?
    public override init(texture: SKTexture?, color: UIColor, size: CGSize ) {
        self.typeGround = TypeGround.Rock
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
        
    }
    public convenience init(texture: SKTexture?, color: UIColor, size: CGSize,typeGround:TypeGround) {
        self.init(texture: nil, color: color, size: size)
        self.typeGround = typeGround
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func touchDown(atPoint pos : CGPoint) {
        self.delgate?.sendType(ground: self)
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
