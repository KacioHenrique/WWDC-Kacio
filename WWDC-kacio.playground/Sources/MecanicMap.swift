//
//  MecanicMap.swift
//  indoComTilemap
//
//  Created by kacio henrique couto batista on 18/03/19.
//  Copyright © 2019 kacio henrique couto batista. All rights reserved.
//

import Foundation
import SpriteKit

public class MecanicMap: NSObject , MapResponde {
    let rows:Int
    let columns:Int
    var map:MapUpdate?
    var tileSet:SKTileSet?
    var baseElements:[String]
    var atualRow:Int = 0
    var paint:SKTileGroup?
    var scene:SKScene
    var sizeObject:[String:CGSize] = ["Rock" : CGSize(width: 180, height: 150) , "Tree" : CGSize(width: 300, height: 220) , "Flower" : CGSize(width: 60, height: 60)]
    var name:String
    var historic:[RedonData] = []
    init(rows:Int , columns:Int , baseElements:[String] , scene:SKScene , name:String) {
        self.rows = rows
        self.columns = columns
        self.baseElements = baseElements
        self.scene = scene
        self.name = name
        super.init()
        self.fristGround( rows: rows, columns: columns)
    }
    func resetTile(col:Int ,row:Int){
        guard let element = tileSet!.tileGroups.first(where: {$0.name == self.name }) else {
            fatalError("No \(self.name) tile definition found")
        }
        self.map?.setTileGroup(element, forColumn: col, row: row)
    }
    func resetMap(){
        if historic.count > 0{
            if historic.last?.type == .tile{
                if let tilefromReset = historic.last {
                    resetTile(col: tilefromReset.col! , row: tilefromReset.row!)
                }
            }
            else {
                self.scene.children.last?.removeFromParent()
            }
            historic.removeLast()
        }
       
    }
    func setTextureTile(name:String){
        guard let element = tileSet!.tileGroups.first(where: {$0.name == name }) else {
            fatalError("No \(name) tile definition found")
        }
        self.paint = element
        self.paint?.name = name
    }
    func colrow(point: CGPoint, row: Int, column: Int) {
            if let paint = self.paint {
                if let name = paint.name{
                    if ["Rock","Tree","Flower"].contains(name){
                        
                        let node = SKSpriteNode(imageNamed:name)
                        node.scale(to:sizeObject[name]!)
                        node.position = point
                        if name == "Flower"{
                            node.run(SKAction.init(named: name)!)
                        }
                        self.scene.addChild(node)
                        self.historic.append(RedonData(name: name, type: .node))
                    }
                        
                    else{
                        if let name = paint.name{
                            map?.setTileGroup(paint, forColumn: column, row: row)
                            var tileHistoric = RedonData(name: name, type: .tile)
                            tileHistoric.col = column
                            tileHistoric.row = row
                            self.historic.append(tileHistoric)
                        }
                    }
                }
            }
    }
    
    func pointDraw(point: CGPoint?) {}
    func fristGround(rows:Int , columns:Int){
        let set = SKTileSet(tileGroups: creatGroupTileSet(listName: [name]))
        set.type = .isometric
        let fristFloor = SKTileMapNode(tileSet: set, columns: self.columns, rows: self.rows, tileSize:SKTexture(imageNamed:"Grass").size())
        guard let element = set.tileGroups.first(where: {$0.name == name}) else {
            fatalError("No Grass frist tile definition found")
        }
        for rows in 0...rows{
            for columns in 0...columns{
                fristFloor.setTileGroup(element, forColumn: rows, row: columns)
            }
        }
        fristFloor.zPosition = -2
        scene.addChild(fristFloor)
    }
    func creatGroupTileSet(listName:[String]) -> [SKTileGroup]{
        let group = listName.map { (name) -> SKTileGroup in
            let texture = SKTexture(imageNamed: name)
            let definition = SKTileDefinition(texture: texture, size: texture.size())
            definition.name = name
            let group = SKTileGroup(tileDefinition: definition)
            group.name = name
            return group
        }
        return group
    }
    func setMap(){
        tileSet = SKTileSet(tileGroups: creatGroupTileSet(listName: baseElements))
        tileSet!.type = .isometric
        map = MapUpdate(tileSet: tileSet!, columns: columns, rows: rows, tileSize:SKTexture(imageNamed: name).size())
        self.map!.delegate = self
        guard let element = tileSet!.tileGroups.first(where: {$0.name == name }) else {
            fatalError("No \(name) tile definition found")
        }
        for rows in 0...rows{
            for columns in 0...columns{
                self.map!.setTileGroup(element, forColumn: rows, row: columns)
            }
        }
    }
}

protocol MapResponde{
    func pointDraw(point:CGPoint?)
    func colrow(point:CGPoint , row:Int , column:Int)
}

class MapUpdate : SKTileMapNode {
    var delegate:MapResponde?
    override init(tileSet: SKTileSet, columns: Int, rows: Int, tileSize: CGSize) {
        super.init(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        self.isUserInteractionEnabled = true
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let row = self.tileRowIndex(fromPosition: pos)
        let column = self.tileColumnIndex(fromPosition: pos)
        print(pos)
      
        if (row >= 0 && row < self.numberOfRows && column >= 0 && column < self.numberOfColumns){
            print((row , column))
            self.delegate?.colrow(point:pos, row: row, column: column)
        }
        
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
