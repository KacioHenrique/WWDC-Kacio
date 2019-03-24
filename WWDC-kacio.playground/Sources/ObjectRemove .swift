//
//  ObectRemove .swift
//  wwdc-kacio
//
//  Created by Kacio on 3/22/19.
//  Copyright © 2019 Kacio. All rights reserved.
//

import Foundation
import SpriteKit
public class ObjectRemove:SKSpriteNode{
    var remove = false
    var delgate:Remove?
    override init(texture: SKTexture?, color: UIColor, size: CGSize ) {
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = false
        
    }
   
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func touchDown(atPoint pos : CGPoint) {
        self.delgate?.sendNodeFromRemove(node: self)
    }
    public func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    public func touchUp(atPoint pos : CGPoint) {
        print("here")
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
public protocol Remove {
    func sendNodeFromRemove(node:SKNode)
}
