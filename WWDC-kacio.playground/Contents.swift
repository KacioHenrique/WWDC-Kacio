//: A SpriteKit based Playground
/*:
 
 # Little World Maker
 ![alternate text ](MAP.png)
 This PlayGround was produced based on the idea of the maximum stimulation of anybody's creativity. Through interactive objects and ground styles you can free your imagination and play as you wish.
 
 Little World Maker is not a game, however it is a interesting tool that helps you to develop your creativity composing many environment possibilities in a limited space.

 
 ## How to use
 ### Tap on the creation icon
![alternate text](Draw.png)
 ### Tap on the "Undone" icon
![alternate text](undoExplicaco.png)
 ### Tap on the "Remove" icon
 you can remove only the objects in red

 ![alternate text](Remove.png)
 
 */

import PlaygroundSupport
import SpriteKit
import AVFoundation
var player:AVAudioPlayer? = nil
public func playBackgroundSound(player:inout AVAudioPlayer?) {
    guard let url = Bundle.main.url(forResource: "MusicGame", withExtension: "mp3") else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        try AVAudioSession.sharedInstance().setActive(true)
        
        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        
        guard let player = player else { return }
        
        player.volume = 0.6
        player.numberOfLoops = -1
        player.play()
    }
    catch let error {
        print(error.localizedDescription)
    }
}
playBackgroundSound(player: &player)
// Load the SKScene from 'GameScene.sks'
let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
if let scene = GameScene(fileNamed: "GameScene") {
    // Set the scale mode to scale to fit the window
    scene.scaleMode = .aspectFill
    
    // Present the scene
    sceneView.presentScene(scene)
}
// Play Song
// WARNING: modifying function

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
