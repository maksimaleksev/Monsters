//
//  MonsterViewController.swift
//  Monsters
//
//  Created by Maxim Alekseev on 08.01.2021.
//

import UIKit
import SceneKit
import ARKit

protocol MonsterViewProtocol: class {
    var presenter: MonsterPresenterProtocol! { get set }
    
    func setStatusLabelText(trackingStatus: String, statusMessage: String)
    func setAnnotationLabelTextCaseMonster(monsterName: String, monsterLevel: String)
    func launchPokeBall()
    func setupAfterMonsterCatched()
    
}


class MonsterViewController: UIViewController {
    
    //MARK: - Properties
    
    var presenter: MonsterPresenterProtocol!
    private let viewsCornerRadius: CGFloat = 5
    lazy var monsterNode: SCNNode? = presenter.createScene()?.node
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var annotationView: UIView!
    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionButtonLeadingAnhcorToResetButton: NSLayoutConstraint!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initScene()
        self.initARSession()
        self.initCoachingOverlayView()
        self.initFocusNode()
        
    }
    
    override func viewDidLayoutSubviews() {
        annotationView.layer.cornerRadius = viewsCornerRadius
        resetButton.layer.cornerRadius = viewsCornerRadius
        actionButton.layer.cornerRadius = viewsCornerRadius
    }
    
    deinit {
        print ("MonsterViewController deinit")
    }
    
    
    //MARK: - IBActions
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        self.resetARSession()
        
    }
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        presenter.action()
    }
    
}


//MARK: - MonsterViewProtocol
extension MonsterViewController: MonsterViewProtocol {
    func setupAfterMonsterCatched() {
        sceneView.session.pause()
        resetButton.isEnabled = false
        annotationView.isHidden = true
                        
        actionButton.setTitle("Вернуться к картам", for: .normal)
        presenter.setVCState(.MonsterCatched)
        presenter.updateStatus()
    }
    
    
    func setAnnotationLabelTextCaseMonster(monsterName: String, monsterLevel: String) {
        self.annotationLabel.text = monsterName + ",\nуровень: " + monsterLevel
        annotationView.isHidden = false
    }
    
    
    func setStatusLabelText(trackingStatus: String, statusMessage: String) {
        self.statusLabel.text = trackingStatus != "" ?
            "\(trackingStatus)" : "\(statusMessage)"
    }
    
    private func getUserVector() -> (SCNVector3, SCNVector3) {
        
        if let frame = self.sceneView.session.currentFrame {
            
            let matrix = SCNMatrix4(frame.camera.transform)
            let direction = SCNVector3(-1 * matrix.m31, -1 * matrix.m32, -1 * matrix.m33)
            let position = SCNVector3(matrix.m41, matrix.m42, matrix.m43)
            return (direction, position)
        }
        
        return (SCNVector3(0, 0, -1), SCNVector3(0, 0, -0.2))
    }
    
    func launchPokeBall() {
        
        guard let sphereNode = presenter.createPokeBall() else { return }
        
        //get user position and direction
        let (direction, position) = self.getUserVector()
        sphereNode.position = position
        
        var sphereNodeDirection = SCNVector3()
        sphereNodeDirection = SCNVector3(direction.x * 4, direction.y * 4, direction.z * 4)
        sphereNode.physicsBody?.applyForce(sphereNodeDirection, at: SCNVector3(0.1, 0, 0), asImpulse: true)
        
        //move node
        sphereNode.physicsBody?.applyForce(sphereNodeDirection, asImpulse: true)
        
        //add node to scene
        
        sceneView.scene.rootNode.addChildNode(sphereNode)
        
    }
}


// MARK: - ViewController Management
extension MonsterViewController {
    
    
    private func startApp() {
        DispatchQueue.main.async {
            self.presenter.setVCState(.DetectSurface)
        }
    }
    
    private func resetApp() {
        DispatchQueue.main.async {
            self.resetARSession()
            self.presenter.setVCState(.DetectSurface)
        }
    }
}

// MARK: - AR Coaching Overlay
extension MonsterViewController: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        
    }
    
    func coachingOverlayViewDidDeactivate(_
                                            coachingOverlayView: ARCoachingOverlayView) {
        self.startApp()
    }
    
    
    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
        self.resetApp()
    }
    
    
    private func initCoachingOverlayView() {
        
        let coachingOverlay = ARCoachingOverlayView()
        
        coachingOverlay.session = self.sceneView.session
        
        coachingOverlay.delegate = self
        
        coachingOverlay.activatesAutomatically = true
        
        coachingOverlay.goal = .horizontalPlane
        
        self.sceneView.addSubview(coachingOverlay)
        
        //Setup constraints
        
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                                        
                                        NSLayoutConstraint(item: coachingOverlay,
                                                           attribute: .top, relatedBy: .equal,
                                                           toItem: self.view, attribute: .top,
                                                           multiplier: 1, constant: 0),
                                        
                                        NSLayoutConstraint(item:  coachingOverlay,
                                                           attribute: .bottom, relatedBy: .equal,
                                                           toItem: self.view, attribute: .bottom,
                                                           multiplier: 1, constant: 0),
                                        
                                        NSLayoutConstraint(item:  coachingOverlay,
                                                           attribute: .leading, relatedBy: .equal,
                                                           toItem: self.view, attribute: .leading,
                                                           multiplier: 1, constant: 0),
                                        
                                        NSLayoutConstraint(item:  coachingOverlay,
                                                           attribute: .trailing, relatedBy: .equal,
                                                           toItem: self.view, attribute: .trailing,
                                                           multiplier: 1, constant: 0)])
        
    }
    
}

// MARK: - AR Session Management

extension MonsterViewController  {
    
    private func initARSession() {
        
        guard ARWorldTrackingConfiguration.isSupported else {
            print("*** ARConfig: AR World Tracking Not Supported")
            return
        }
        
        let config = ARWorldTrackingConfiguration()
        
        config.worldAlignment = .gravity
        config.providesAudioData = false
        config.planeDetection = .horizontal
        config.isLightEstimationEnabled = true
        config.environmentTexturing = .automatic
        
        sceneView.session.run(config)
    }
    
    private func resetARSession() {
        
        monsterNode?.isHidden = true
        
        let config = sceneView.session.configuration as!
            ARWorldTrackingConfiguration
        
        config.planeDetection = .horizontal
        
        sceneView.session.run(config,
                              options: [.resetTracking, .removeExistingAnchors])
    }
    
    
    
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        switch camera.trackingState {
        
        case .notAvailable: presenter.setTrackingStatus("Tracking:  Not available!")
        case .normal: presenter.setTrackingStatus("")
        case .limited(let reason):
            
            switch reason {
            
            case .excessiveMotion: presenter.setTrackingStatus("Tracking: Limited due to excessive motion!")
            case .insufficientFeatures: presenter.setTrackingStatus("Tracking: Limited due to insufficient features!")
            case .relocalizing: presenter.setTrackingStatus("Tracking: Relocalizing...")
            case .initializing: presenter.setTrackingStatus("Tracking: Initializing...")
            @unknown default: presenter.setTrackingStatus("Tracking: Unknown...")
                
            }
            
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        presenter.setTrackingStatus("AR Session Failure: \(error)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        presenter.setTrackingStatus("AR Session Was Interrupted!")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        presenter.setTrackingStatus("AR Session Interruption Ended")
    }
}

// MARK: - Scene Management
extension MonsterViewController: ARSCNViewDelegate {
    
    private func initScene() {
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        sceneView.delegate = self
        
        sceneView.scene.physicsWorld.contactDelegate = self
        
        guard let monsterNode = monsterNode else { return }
        monsterNode.isHidden = true
        sceneView.scene.rootNode.addChildNode(monsterNode)
        
        
        //        // 1
        //        sceneView.showsStatistics = true
        //        // 2
        //        sceneView.debugOptions = [
        //          ARSCNDebugOptions.showFeaturePoints,
        //          ARSCNDebugOptions.showCreases,
        //          ARSCNDebugOptions.showWorldOrigin,
        //          ARSCNDebugOptions.showBoundingBoxes,
        //          ARSCNDebugOptions.showWireframe]
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.presenter.updateStatus()
            self.updateFocusNode()
        }
    }
}

// MARK: - Focus Node Management
extension MonsterViewController {
    
    private func initFocusNode() {
        presenter.setFocusPoint(CGPoint(x: view.center.x,
                                        y: view.center.y + view.center.y * 0.1))
    }
    
    private func updateFocusNode() {
        
        guard presenter.vcState != .Started else { return }
        
        if let query = self.sceneView.raycastQuery(
            from: presenter.focusPoint,
            allowing: .estimatedPlane,
            alignment: .horizontal) {
            
            let results = self.sceneView.session.raycast(query)
            
            if results.count == 1 {
                if let match = results.first {
                    
                    let t = match.worldTransform
                    
                    self.monsterNode?.isHidden = false
                    
                    self.monsterNode?.position = SCNVector3(x: t.columns.3.x, y: t.columns.3.y, z: t.columns.3.z)
                    
                    guard presenter.vcState != .MonsterCatched else { return }
                    presenter.setVCState(.Started)
                    actionButton.isHidden = false
                    presenter.setAnnotationView()
                    
                }
                
            } else {
                
                guard presenter.vcState != .MonsterCatched else { return }
                
                presenter.setVCState(.PointAtSurface)
                
                monsterNode?.isHidden = true
            }
        }
    }
}

//MARK: - SCNPhysicsContactDelegate

extension MonsterViewController: SCNPhysicsContactDelegate {
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
                       
        DispatchQueue.main.async {
            contact.nodeA.removeFromParentNode()
            contact.nodeB.removeFromParentNode()
            self.setupAfterMonsterCatched()
        }
    }
}

