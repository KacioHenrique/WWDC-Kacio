//
//  redoButton.swift
//  wwdc-kacio
//
//  Created by Kacio on 3/21/19.
//  Copyright © 2019 Kacio. All rights reserved.
//

import Foundation
import SpriteKit
public class ButtonEditorInMap:SKSpriteNode{
    var delgate:ButtonElement?
    var type:ButtonEditor
    override init(texture: SKTexture?, color: UIColor, size: CGSize ) {
        type = .caseNot
        super.init(texture: texture, color: color, size: size)
        self.isUserInteractionEnabled = true
    }
    public convenience init(texture: SKTexture? , size: CGSize,type:ButtonEditor) {
        self.init(texture: texture, size: size)
        self.type = type
        self.color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func touchDown(atPoint pos : CGPoint) {
        print("down in redo")
        delgate?.call(type: type)
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
public enum ButtonEditor{
    case undo
    case remove
    case caseNot
}
public enum TypeObejectRedon {
    case tile(String,Int,Int)
    case node(SKNode)
}
public struct RedonData{
    let objectInMap:TypeObejectRedon
    init(objectInMap:TypeObejectRedon) {
        self.objectInMap = objectInMap
    }
   
}
func tileIsNew(col:Int,row:Int, name:String ,object :TypeObejectRedon) -> Bool {
    switch object {
    case .node(_):
        return true
    case .tile(_, let elementCol,let elementRow):
        if(elementCol == col && elementRow == row){ return false}
        else{
            return true
        }
    }
}
