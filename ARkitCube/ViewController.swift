//
//  ViewController.swift
//  ARkitCube
//
//  Created by YuanLin on 3/19/25.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel! // Add this outlet

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self //Also set the session's delegate

        // Show statistics such as FPS and timing information
        sceneView.showsStatistics = true

        // Create a new scene
        let scene = SCNScene()

        // Set the scene to the view
        sceneView.scene = scene

        statusLabel.text = "Initializing AR..."
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal // Enable plane detection

        // Run the view's session
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place a cube when a new AR anchor is detected
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        DispatchQueue.main.async {
                    // Create the geometry
                    let cubeGeometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)

                    // Create materials for each face
                    let redMaterial = SCNMaterial()
                    redMaterial.diffuse.contents = UIColor.red

                    let greenMaterial = SCNMaterial()
                    greenMaterial.diffuse.contents = UIColor.green

                    let blueMaterial = SCNMaterial()
                    blueMaterial.diffuse.contents = UIColor.blue

                    let yellowMaterial = SCNMaterial()
                    yellowMaterial.diffuse.contents = UIColor.yellow

                    let orangeMaterial = SCNMaterial()
                    orangeMaterial.diffuse.contents = UIColor.orange

                    let purpleMaterial = SCNMaterial()
                    purpleMaterial.diffuse.contents = UIColor.purple

                    // Assign the materials to the geometry
                    cubeGeometry.materials = [redMaterial, greenMaterial, blueMaterial, yellowMaterial, orangeMaterial, purpleMaterial]

                    // Create the node
                    let cubeNode = SCNNode(geometry: cubeGeometry)

                    // Set the node's position
                    cubeNode.position = SCNVector3(planeAnchor.center.x, 0.05, planeAnchor.center.z)

                    // Add the cube to the node
                    node.addChildNode(cubeNode)

                    self.statusLabel.text = "Plane detected, multi-colored cube added!"
                    print("Added a cube to the scene!")
                }
    }

    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        statusLabel.text = "AR Session Failed: \(error.localizedDescription)"
        print("AR Session Failed: \(error)")
    }

    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        statusLabel.text = "AR Session Interrupted"
        print("AR Session Interrupted")
    }

    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        statusLabel.text = "AR Session Interruption Ended, Resetting..."
        print("AR Session Interruption Ended")
        resetTracking()
    }

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // Called every frame

    }

    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        statusLabel.text = "Initializing AR..."
    }
}
