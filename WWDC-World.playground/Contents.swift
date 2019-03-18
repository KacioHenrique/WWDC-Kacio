//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit
// Load the SKScene from 'GameScene.sks'

public class GameScene: SKScene ,Button{
    public var tileMap:SKTileMapNode?
    public var test:SKTileGroup?
    let cameraNode = SKCameraNode()
    var tileSet:SKTileSet?
    let gesture = UIPinchGestureRecognizer()
    public let button = GroundButton(texture: nil, color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), size: CGSize(width: 100, height: 100), typeGround: TypeGround.Water)
    public let button1 = GroundButton(texture: nil, color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), size: CGSize(width: 100, height: 100), typeGround: TypeGround.Tree)
    override public func didMove(to view: SKView) {
        button.delgate = self
        button1.delgate = self
        button1.texture = SKTexture(imageNamed: "Tree")
        button.position.x = self.scene!.frame.midX - button.size.width
        button1.position.x = self.scene!.frame.midX - button.size.width * 2
        button1.zPosition = 3
        button.zPosition = button1.zPosition
        self.addChild(button1)
        self.addChild(button)
        setMap(rows: 64, columns: 64, name: "Grass")
        
        self.cameraNode.setScale(4)
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        setGestures()
    }
    public func sendType(ground:GroundButton) {
        print("eu toquei no buttão do tipo \(ground.typeGround.rawValue)")
        self.test = setTextureTile(name: ground.typeGround.rawValue)
    }
    public func touchDown(atPoint pos : CGPoint) {
        if let column = tileMap?.tileColumnIndex(fromPosition: pos),let row = tileMap?.tileRowIndex(fromPosition: pos){
            if let definition = tileMap?.tileDefinition(atColumn: column, row: row){
                if let test = self.test{
                    //definition.size = SKTexture(imageNamed: "Tree").size()
                    tileMap!.setTileGroup(test, andTileDefinition:definition, forColumn: column, row: row)
                }
                
            }
            
        }
    }
    
    public func touchMoved(toPoint pos : CGPoint) {
        if let column = tileMap?.tileColumnIndex(fromPosition: pos),let row = tileMap?.tileRowIndex(fromPosition: pos){
            if let definition = tileMap?.tileDefinition(atColumn: column, row: row){
                tileMap?.setTileGroup(self.test!, andTileDefinition: definition, forColumn: column, row: row)
            }
            
        }
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
    }
}
public extension GameScene{
    func setGestures(){
        gesture.addTarget(self, action: #selector(self.pince(_:)))
        self.view?.addGestureRecognizer(gesture)
    }
    func setTextureTile(name:String) -> SKTileGroup{
        
        guard let element = tileSet!.tileGroups.first(where: {$0.name == name }) else {
            fatalError("No \(name) tile definition found")
        }
        return element
    }
    func setMap(rows:Int , columns:Int , name:String){
        let texture = SKTexture(imageNamed: name)
        let size = CGSize(width: texture.size().width, height: texture.size().height)
        let tile = SKTileDefinition(texture:texture)
        
        let tile2 = SKTileDefinition(texture:SKTexture(imageNamed:"Water"), size: SKTexture(imageNamed:"Water").size())
        let tile3 = SKTileDefinition(texture:SKTexture(imageNamed:"Tree"),size:SKTexture(imageNamed:"Tree").size())
        let group = SKTileGroup(tileDefinition: tile)
        let group2 = SKTileGroup(tileDefinition: tile2)
        let group3 = SKTileGroup(tileDefinition: tile3)
        group.name = name
        group2.name = "Water"
        group3.name = "Tree"
        tileSet = SKTileSet(tileGroups: [group ,group2,group3])
        tileSet!.type = .isometric
        tileMap = SKTileMapNode(tileSet: tileSet!, columns: columns, rows: rows, tileSize:size)
        if let tilemap = self.tileMap {
            self.addChild(tilemap)
        }
        guard let element = tileSet!.tileGroups.first(where: {$0.name == name }) else {
            fatalError("No \(name) tile definition found")
        }
        self.test = element
        for row in 0...rows {
            for column in 0...columns{
                tileMap?.setTileGroup(test, forColumn: row, row: column)
            }
            
        }
    }
    @objc func pince(_ gesture:UIPinchGestureRecognizer){
        let mimScale:CGFloat = 0.2
        let maxScale:CGFloat = 15
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
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}


PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
