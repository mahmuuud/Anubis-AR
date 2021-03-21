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

enum ModelType: String {
    case mask
    case cat
    case sphinx
    case tut
    case tut1
    case nefer
}

class ARViewController: UIViewController {
    @IBOutlet weak var arView: ARView!
    @IBOutlet weak var overlayView: ARCoachingOverlayView!
    
    var appState: AppState = .waiting
    var modelType: ModelType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayView.session = arView.session
        overlayView.goal = .horizontalPlane
        overlayView.activatesAutomatically = true
        arView.session.delegate = self
        detectPlanes(.horizontal)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        placeModel()
    }
    
    func placeModel() {
        guard let modelType = self.modelType else {
            return
        }
        switch modelType {
        case .mask:
            MyScene.loadTutMaskAsync { (result) in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        let anchor = AnchorEntity(plane: .horizontal)
                        self.arView.scene.addAnchor(anchor)
                        model.scale = [1, 1, 1] * 0.00006
                        anchor.children.append(model)
                    }
                    
                case .failure(let error):
                    self.showAlert(planeType: error.localizedDescription)
                    
                }
            }
        case .cat:
            MyScene.loadCatAsync { (result) in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        let anchor = AnchorEntity(plane: .horizontal)
                        self.arView.scene.addAnchor(anchor)
                        model.scale = [1, 1, 1] * 0.00006
                        anchor.children.append(model)
                    }
                    
                case .failure(let error):
                    self.showAlert(planeType: error.localizedDescription)
                    
                }
            }
            
        case .sphinx:
            MyScene.loadSphinxAsync { (result) in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        let anchor = AnchorEntity(plane: .horizontal)
                        self.arView.scene.addAnchor(anchor)
                        model.scale = [1, 1, 1] * 0.00006
                        anchor.children.append(model)
                    }
                    
                case .failure(let error):
                    self.showAlert(planeType: error.localizedDescription)
                    
                }
            }
            
        case .tut:
            MyScene.loadTutAsync { (result) in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        let anchor = AnchorEntity(plane: .horizontal)
                        self.arView.scene.addAnchor(anchor)
                        model.scale = [1, 1, 1] * 0.00006
                        anchor.children.append(model)
                    }
                    
                case .failure(let error):
                    self.showAlert(planeType: error.localizedDescription)
                    
                }
            }
            
        case .tut1:
            MyScene.loadTutOneAsync { (result) in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        let anchor = AnchorEntity(plane: .horizontal)
                        self.arView.scene.addAnchor(anchor)
                        model.scale = [1, 1, 1] * 0.00006
                        anchor.children.append(model)
                    }
                    
                case .failure(let error):
                    self.showAlert(planeType: error.localizedDescription)
                    
                }
            }
            
        case .nefer:
            MyScene.loadNefertAsync { (result) in
                switch result {
                case .success(let model):
                    DispatchQueue.main.async {
                        let anchor = AnchorEntity(plane: .horizontal)
                        self.arView.scene.addAnchor(anchor)
                        model.scale = [1, 1, 1] * 0.00006
                        anchor.children.append(model)
                    }
                    
                case .failure(let error):
                    self.showAlert(planeType: error.localizedDescription)
                    
                }
            }
            
            
        }
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

