//
//  GameScene.swift
//  indoComTilemap
//
//  Created by kacio henrique couto batista on 16/03/19.
//  Copyright © 2019 kacio henrique couto batista. All rights reserved.
//

import SpriteKit
import GameplayKit
public class GameScene: SKScene ,ButtonElement {
    public func call() {
        self.mecanic?.resetMap()
    }
    
    var cameraNode:SKCameraNode!
    let gesturePinch = UIPinchGestureRecognizer()
    let gestureLongPress = UILongPressGestureRecognizer()
    let buttonUIName:[String] = ["Water","Sand","Rock","Grass","Tree","Flower"]
    var mecanic:MecanicMap?
    public override func didMove(to view: SKView) {
        self.setCameraNode()
        setGestures()
        self.initButton(listButton: buttonUIName)
        mecanic = MecanicMap(rows: 8, columns: 8, baseElements: self.buttonUIName ,scene: self.scene!, name: "Sand")
        mecanic?.setMap()
        mecanic?.map?.name = "world"
        self.addChild(mecanic!.map!)
        
    }
    
    func setCameraNode(){
        if let cam = self.childNode(withName:"SKCameraNode") as? SKCameraNode{
            self.cameraNode = cam
            self.cameraNode.setScale(CGFloat(3))
        }
        self.scene?.camera = self.cameraNode
        
    }
    func initButton(listButton:[String]){
        let groundButtonUI = self.children.filter { (node) -> Bool in
            if let node = node as? SKSpriteNode{
                if node.name != nil{
                    return buttonUIName.contains(node.name!)
                }
            }
            return false
        }
        let _ = groundButtonUI.map({ (node) -> [GroundButton] in
            if let spriteNode = node as? SKSpriteNode {
                let button = GroundButton(texture: spriteNode.texture, size:CGSize(width:100, height:100), typeGround:typeforName(spriteNode.name))
                button.name = spriteNode.name
                button.position = spriteNode.position
                self.cameraNode.addChild(button)
                button.delgate = self
                button.zPosition = spriteNode.zPosition
                spriteNode.removeFromParent()
                return [button]
            }
            return []
        })
        // init redoButton
        if let node = self.scene?.childNode(withName: "Redo") as? SKSpriteNode{
            let buttonRedo = RedoButton(texture: node.texture, color: node.color, size: node.size)
            buttonRedo.position = node.position
            buttonRedo.zPosition = node.zPosition
            node.removeFromParent()
            buttonRedo.delgate = self
            self.cameraNode.addChild(buttonRedo)
        }
    }
    public func sendType(ground:GroundButton) {
        let _ = cameraNode.children.map { (node) -> SKNode in
            if let button = node as? GroundButton{
                if button.name == ground.typeGround.rawValue{
                    button.selectColor(value: true)
                }
                else{
                    button.selectColor(value: false)
                }
            }
            return node
        }
        
        mecanic?.setTextureTile(name: ground.typeGround.rawValue)
    }
    public func touchDown(atPoint pos : CGPoint) {
    }
    
    public func touchMoved(toPoint pos : CGPoint) {
        //print("move")
        //self.cameraNode.run(SKAction.moveBy(x: pos.x, y: pos.y, duration: 1))
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
    
    
    public override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //print(self.mecanic?.atualRow)
    }
    func setGestures(){
        gesturePinch.addTarget(self, action: #selector(self.pince(_:)))
        self.view?.addGestureRecognizer(gesturePinch)
        self.view?.addGestureRecognizer(gestureLongPress)
    }
    
    @objc func pince(_ gesture:UIPinchGestureRecognizer){
        let mimScale:CGFloat = 1.0538035023024337
        let maxScale:CGFloat = 10
        //print(gesture.scale)
        guard let camera = self.camera else{
            return
        }
        if gesture.state == .changed {
            var scale = camera.xScale/gesture.scale.magnitude
            if(scale > maxScale){
                scale = maxScale
            }else if (mimScale > scale){
                scale = mimScale
            }
            self.cameraNode.setScale(scale)
        }
    }
}
