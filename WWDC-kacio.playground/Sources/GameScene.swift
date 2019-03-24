//
//  GameScene.swift
//  indoComTilemap
//
//  Created by kacio henrique couto batista on 16/03/19.
//  Copyright © 2019 kacio henrique couto batista. All rights reserved.
//

import SpriteKit
import GameplayKit
public class GameScene: SKScene , ButtonElement, Remove{
    var cameraNode:SKCameraNode!
    let gesturePinch = UIPinchGestureRecognizer()
    let gestureLongPress = UILongPressGestureRecognizer()
    let buttonUIName:[String] = ["Water","Sand","Rock","Grass","Tree","Flower"]
    var modoRemover:Bool = false
    var mecanic:MecanicMap?
    var buttonRemover:ButtonEditorInMap?
    var buttonUndo:ButtonEditorInMap?
    public override func didMove(to view: SKView) {
        self.setCameraNode()
        setGestures()
        self.initButton(listButton: buttonUIName)
        mecanic = MecanicMap(rows: 8, columns: 8, baseElements: self.buttonUIName ,scene:self as! GameScene, name: "Sand")
        mecanic?.setMap()
        mecanic?.map?.name = "world"
        self.addChild(mecanic!.map!)
        self.scene?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    func createColorize() -> SKShader {
        let uniforms: [SKUniform] = [
            SKUniform(name: "u_color", color: .red),
            SKUniform(name: "u_strength", float: 0.5)
        ]
        
        return SKShader(fromFile: "SHKColorize", uniforms: uniforms)
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
                let button = GroundButton(texture: spriteNode.texture, size:CGSize(width:50, height:50), typeGround:typeforName(spriteNode.name))
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
            let buttonRedo = ButtonEditorInMap(texture: node.texture, size: node.size , type:.undo)
            buttonRedo.position = node.position
            buttonRedo.zPosition = node.zPosition
            node.removeFromParent()
            buttonRedo.delgate = self
            self.buttonUndo = buttonRedo
            self.cameraNode.addChild(self.buttonUndo!)
        }
        if let node = self.scene?.childNode(withName: "Remove") as? SKSpriteNode{
            let buttonRedo = ButtonEditorInMap(texture: node.texture , size:node.size, type:.remove)
            buttonRedo.position = node.position
            buttonRedo.zPosition = node.zPosition
            node.removeFromParent()
            buttonRedo.delgate = self
            self.buttonRemover = buttonRedo
            self.cameraNode.addChild(buttonRemover!)
        }
    }
    public func call(type: ButtonEditor) {
        if type == .undo {
             self.mecanic?.deleteFromMap()
            self.buttonUndo?.run(SKAction.init(named:"undo")!)
        }
        if type == .remove{
            self.modoRemover = !self.modoRemover
            if modoRemover {
                colorizeNodes()
                mecanic?.canDraw = false
                self.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
                self.buttonRemover?.texture = SKTexture(imageNamed: "DontSelect")
            }
            else {
                dontColorizeNode()
                mecanic?.canDraw = true
                self.buttonRemover?.texture = SKTexture(imageNamed: "Select")
                self.scene?.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }
        else{
            
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
    public func sendNodeFromRemove(node: SKNode) {
        if modoRemover {
            self.removeChildren(in: [node])
            
        }
    }
    func colorizeNodes(){
        let _ = self.children.map { (node) in
            if let sprite = node as? ObjectRemove{
                sprite.shader = createColorize()
                sprite.isUserInteractionEnabled = true
            }
        }
    }
    func dontColorizeNode(){
        let _ = self.children.map { (node) in
            if let sprite = node as? ObjectRemove{
                sprite.shader = nil
                sprite.isUserInteractionEnabled = false
            }
        }
    }
}
