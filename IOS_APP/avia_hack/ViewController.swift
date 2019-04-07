//
//  ViewController.swift
//  avia_hack
//
//  Created by Denis Gnezdilov on 06/04/2019.
//  Copyright © 2019 -. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

import Starscream
import SocketIO

import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {
    
    struct Const {
        static let lightShotNode1 = "lightshot1"
        static let lightShotNode2 = "lightshot2"
        static let blaster = "blaster"
        
        static let particles1 = "particles1"
        static let particles2 = "particles2"
        
        static let rootSatellite1 = "rootSatellite1"
        static let rootSatellite2 = "rootSatellite2"
        
        static let satellite1 = "satellite1"
        static let satellite2 = "satellite2"

        static let particlesExit = "particlesExit"
    }

    @IBOutlet var sceneView: ARSCNView!
    
    var socket: WebSocket!
    
    var isRotating = false
    
    var player: AVAudioPlayer?
    
    var quit: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "megoScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Socket connect
//        var request = URLRequest(url: URL(string: "http://192.168.88.127:5204")!)
//        request.timeoutInterval = 5
//        socket = WebSocket(request: request)
//        socket.delegate = self
//
//        socket.onConnect = {
//            print("websocket is connected")
//        }
//        socket.connect()

//        let manager = SocketManager(socketURL: URL(string: "http://192.168.88.127:5204")!,
//                                    config: [.log(true),
//                                             .compress])
//        let socket = manager.defaultSocket
//
//        socket.on(clientEvent: .connect) {data, ack in
//            print("socket connected")
//        }
//
//        socket.on(clientEvent: .disconnect) {data, ack in
//            print("socket disconnect")
//        }
//
//        socket.on("currentAmount") {data, ack in
//            guard let cur = data[0] as? Double else { return }
//
//            socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
//                socket.emit("update", ["amount": cur + 2.50])
//            }
//
//            ack.with("Got your currentAmount", "dude")
//        }
//
//        socket.connect()
        Sock.shared.delegate = self
        Sock.shared.connect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            do {
                guard let satellite = self.sceneView.scene.rootNode.childNode(withName: Const.satellite1, recursively: true) else { return }
                let rotateOneSatellite = SCNAction.rotateBy(x: 0,
                                                            y: CGFloat(Float.pi),
                                                            z: 0,
                                                            duration: 4)
                
                let rotateAlwaysSatellite = SCNAction.repeatForever(rotateOneSatellite)
                satellite.runAction(rotateAlwaysSatellite)
            }
            
            do {
                guard let satellite = self.sceneView.scene.rootNode.childNode(withName: Const.satellite2, recursively: true) else { return }
                let rotateOneSatellite = SCNAction.rotateBy(x: 0,
                                                            y: CGFloat(Float.pi),
                                                            z: 0,
                                                            duration: 4)
                
                let rotateAlwaysSatellite = SCNAction.repeatForever(rotateOneSatellite)
                satellite.runAction(rotateAlwaysSatellite)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    // Actions

    @IBAction func onAction(_ sender: Any) {
        //destroyAll()
    }
    
    @IBAction func rghtAction(_ sender: Any) {
        rotaterBlasterRight()
    }
    
    @IBAction func leftACction(_ sender: Any) {
        rotaterBlasterLeft()
    }
    
}

// MARK: Action lightShot

extension ViewController {
    
    func lightShot() {
//        do {
//            guard let lightShotNode = sceneView.scene.rootNode.childNode(withName: Const.lightShotNode1, recursively: true) else { return }
//
//            let boxNode: SCNNode  = {
//                let box = SCNBox(width: 0.01, height: 0.01, length: 0.05, chamferRadius: 0.01)
//                return SCNNode(geometry: box)
//            }()
//
//            lightShotNode.addChildNode(boxNode)
//            boxNode.position = SCNVector3(0, 0, 0)
//            addShotAnimation(node: boxNode)
//        }

//        do {
//            guard let lightShotNode = sceneView.scene.rootNode.childNode(withName: Const.lightShotNode2, recursively: true) else { return }
//
//            let boxNode: SCNNode  = {
//                let box = SCNBox(width: 0.01, height: 0.01, length: 0.05, chamferRadius: 0.01)
//                return SCNNode(geometry: box)
//            }()
//
//            lightShotNode.addChildNode(boxNode)
//            boxNode.position = SCNVector3(0, 0, 0)
//            addShotAnimation(node: boxNode)
//        }
        playSound()
        do {
            guard let particles = sceneView.scene.rootNode.childNode(withName: Const.particles1, recursively: true) else { return }
            particles.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                particles.isHidden = true
            }
        }
        
        do {
            guard let particles = sceneView.scene.rootNode.childNode(withName: Const.particles2, recursively: true) else { return }
            particles.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                particles.isHidden = true
            }
        }
    }
    
    private func addShotAnimation(node: SCNNode) {
        let shotPosition = node.position
        let rotateOne = SCNAction.move(by: SCNVector3(shotPosition.x,
                                                      shotPosition.y,
                                                      shotPosition.z + 2),
                                       duration: 4)
        node.runAction(rotateOne) {
            node.removeFromParentNode()
        }
    }
    
}

// MARK: Action havyShot

extension ViewController {
    
    func havyShot() {

    }
    
}

// MARK: Rotate blaster

extension ViewController {
    
    func rotaterBlasterLeft() {
        rotaterBlaster(at: 10)
    }
    
    func rotaterBlasterRight() {
        rotaterBlaster(at: -10)
    }
    
    func rotaterBlaster(at angle: Float = 10) {
        guard let blasterNode = sceneView.scene.rootNode.childNode(withName: Const.blaster, recursively: true) else { return }
        blasterNode.removeAllActions()
        let angle = (Float.pi / 90) * angle
        let rotateOne = SCNAction.rotateBy(x: 0,
                                           y: CGFloat(angle),
                                           z: 0,
                                           duration: CATransaction.animationDuration())
        
        blasterNode.runAction(rotateOne) {}
    }
    
}

// MARK: Спутники
extension ViewController {
    
    func rorateSatellites() {
        
        if isRotating {
            isRotating = false
            do {
                guard let rootSatellite = sceneView.scene.rootNode.childNode(withName: Const.rootSatellite1, recursively: true) else { return }
                rootSatellite.removeAllActions()
            }
            do {
                guard let rootSatellite = sceneView.scene.rootNode.childNode(withName: Const.rootSatellite2, recursively: true) else { return }
                rootSatellite.removeAllActions()
            }
            return
        }
        
        isRotating = true

        do {
            guard let rootSatellite = sceneView.scene.rootNode.childNode(withName: Const.rootSatellite1, recursively: true) else { return }
            let rotateOne = SCNAction.rotateBy(x: 0,
                                               y: 0,
                                               z: CGFloat(Float.pi),
                                               duration: 6)
            
            let rotateAlways = SCNAction.repeatForever(rotateOne)
            rootSatellite.runAction(rotateAlways)
        }
        
        do {
            guard let rootSatellite = sceneView.scene.rootNode.childNode(withName: Const.rootSatellite2, recursively: true) else { return }
            let rotateOne = SCNAction.rotateBy(x: 0,
                                               y: 0,
                                               z: -CGFloat(Float.pi),
                                               duration: 6)
            
            let rotateAlways = SCNAction.repeatForever(rotateOne)
            rootSatellite.runAction(rotateAlways)
        }
    }
    
}

extension ViewController {
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "shot2", withExtension: "mov") else { return }
        
        do {
            if player == nil {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            }
            
            guard let player = player else { return }
            
            if !player.isPlaying {
                player.play()
            }
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}

extension ViewController {
    
    func destroyAll() {
        guard let particlesExit = sceneView.scene.rootNode.childNode(withName: Const.particlesExit, recursively: true) else { return }

        let system = particlesExit.particleSystems!.first!
        particlesExit.isHidden = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            system.emissionDuration = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.close(self.quit)
            }
        }
    }
    
    func close(_ falg: Bool) {
        
    }
}

extension ViewController: WebSocketDelegate {
    
    func process(message: String) {
        
        switch (message) {
        case "2":
            rotaterBlasterLeft()
        case "3":
            rotaterBlasterRight()
        case "4":
            lightShot()
        case "5":
            rorateSatellites()
        case "6":
            destroyAll()
        default:
            break
        }
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("Received text: \(text)")
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
    
}
