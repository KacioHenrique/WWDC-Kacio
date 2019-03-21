//
//  redoButton.swift
//  wwdc-kacio
//
//  Created by Kacio on 3/21/19.
//  Copyright © 2019 Kacio. All rights reserved.
//

import Foundation
import SpriteKit
public class RedoButton:SKSpriteNode{
    var delgate:ButtonElement?
    override init(texture: SKTexture?, color: UIColor, size: CGSize ) {
        super.init(texture: texture, color: color, size: size)
        
        self.isUserInteractionEnabled = true
    }
    public convenience init(texture: SKTexture? , size: CGSize,typeGround:TypeGround) {
        self.init(texture: texture, size: size)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func touchDown(atPoint pos : CGPoint) {
        print("down in redo")
        delgate?.call()
    }
    public func selectColor(value:Bool){
     
    }
    public func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    public func touchUp(atPoint pos : CGPoint) {
        
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
public enum TypeObejectRedon {
    case tile
    case node
}
public struct RedonData{
    let name:String
    let type:TypeObejectRedon
    var col:Int?
    var row:Int?
    init(name:String , type:TypeObejectRedon) {
        self.name = name
        self.type = type
        col = nil
        row = nil
    }
}
