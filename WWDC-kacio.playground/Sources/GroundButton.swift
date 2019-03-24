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
    case Flower = "Flower"
}
public func typeforName(_ name:String?) -> TypeGround{
    if (name == "Water"){
        return TypeGround.Water
    }
    if (name == "Grass"){
        return TypeGround.Grass
    }
    if (name == "Sand"){
        return TypeGround.Sand
    }
    if (name == "Rock"){
        return TypeGround.Rock
        
    }
    if(name == "Tree"){
        return TypeGround.Tree
    }
    if(name == "Flower"){
        return TypeGround.Flower
    }
    return TypeGround.Rock
}

public protocol ButtonElement {
    func sendType(ground:GroundButton)
    func call(type:ButtonEditor)
}
public class GroundButton:SKSpriteNode{
    var typeGround:TypeGround
    var delgate:ButtonElement?
    var borda:SKSpriteNode
    override init(texture: SKTexture?, color: UIColor, size: CGSize ) {
        self.typeGround = TypeGround.Rock
        self.borda = SKSpriteNode(texture: texture, color: color, size: size)
        super.init(texture: texture, color: color, size: size)
       
        self.isUserInteractionEnabled = true
    }
    public convenience init(texture: SKTexture? , size: CGSize,typeGround:TypeGround) {
        self.init(texture: texture, size: size)
        self.typeGround = typeGround
        self.borda = SKSpriteNode(texture: nil, color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), size: CGSize(width: size.width * 2, height: size.height * 2))
        self.borda.zPosition = -1
        self.addChild(borda)
    }
   public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func touchDown(atPoint pos : CGPoint) {
        self.delgate?.sendType(ground: self)
      
    }
    public func selectColor(value:Bool){
        if value {
            borda.color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            borda.color = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        }
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
