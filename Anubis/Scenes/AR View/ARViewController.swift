//
//  ARViewController.swift
//  Anubis
//
//  Created by Mahmoud Elkassry on 19/03/2021.
//  Copyright © 2021 ASUFE. All rights reserved.
//

import UIKit
import ARKit
import RealityKit

enum AppState: String {
    case readyToDraw
    case didDraw
    case waiting
}

class ARViewController: UIViewController {
    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var overlayView: ARCoachingOverlayView!
    
    var appState: AppState = .waiting
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.session = arView.session
        overlayView.goal = .horizontalPlane
        overlayView.activatesAutomatically = true
        arView.session.delegate = self
        detectPlanes(.horizontal)
        
        let vase = try! MyScene.loadTutMask()
        
        
        // Place model on a horizontal plane.
        let anchor = AnchorEntity(plane: .horizontal)
        arView.scene.addAnchor(anchor)
        
        vase.scale = [1, 1, 1] * 0.00006
        anchor.children.append(vase)
        
    }
    
    func detectPlanes(_ plane: ARWorldTrackingConfiguration.PlaneDetection) {
        let arConfig = ARWorldTrackingConfiguration()
        arConfig.planeDetection = plane
        arConfig.worldAlignment = .gravity
        arConfig.isLightEstimationEnabled = true
        arView.session.run(arConfig, options: [])
    }
    
    func showAlert(planeType: String) {
        let alert = UIAlertController(title: "Plane Detected!", message: "A \(planeType) plane was detected", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ARViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        guard let anchors = anchors as? [ARPlaneAnchor] else {
//            return
//        }
//        // Unefficient iterations just for explanation
//        if anchors.contains(where: {$0.alignment == .horizontal}) {
//            print("Detected horizontal plane")
//            showAlert(planeType: "Horizontal")
//            do {
//                let vase = try! Entity.load(named: "Tut")
//
//                // Place model on a horizontal plane.
//                let anchor = AnchorEntity(plane: .horizontal)
//                arView.scene.addAnchor(anchor)
//
//                vase.scale = [1, 1, 1] * 0.006
//                anchor.children.append(vase)
//
//            } catch {
//                fatalError("Failed to load asset.")
//            }
//
//        } else if anchors.contains(where: {$0.alignment == .vertical}) {
//            print("Detected vertical plane")
//            showAlert(planeType: "Vertical")
//        }
    }
    
}

extension ARSCNView {
    /**
     Type conversion wrapper for original `unprojectPoint(_:)` method.
     Used in contexts where sticking to SIMD3<Float> type is helpful.
     */
    func unprojectPoint(_ point: SIMD3<Float>) -> SIMD3<Float> {
        return SIMD3<Float>(unprojectPoint(SCNVector3(point)))
    }
    
    // - Tag: CastRayForFocusSquarePosition
    func castRay(for query: ARRaycastQuery) -> [ARRaycastResult] {
        return session.raycast(query)
    }

    // - Tag: GetRaycastQuery
    func getRaycastQuery(for alignment: ARRaycastQuery.TargetAlignment = .any) -> ARRaycastQuery? {
        return raycastQuery(from: screenCenter, allowing: .estimatedPlane, alignment: alignment)
    }
    
    var screenCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
}
