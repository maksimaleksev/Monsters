//
//  MonsterPresenter.swift
//  Monsters
//
//  Created by Maxim Alekseev on 08.01.2021.
//

import Foundation
import SceneKit

protocol MonsterPresenterProtocol: class {
    
    var view: MonsterViewProtocol? { get }
    var monster: MonsterModelProtocol? { get }
    var router: RouterProtocol { get }
    
    var trackingStatus: String { get set }
    var statusMessage: String { get set }
    var vcState: MonsterViewControllerState { get set }
    var focusPoint: CGPoint! { get set}
        
    
    init (view: MonsterViewProtocol, monster: MonsterModelProtocol, router: RouterProtocol)
    
    func createScene() -> ModelScene?
    func goToRootVC()
    func setVCState(_ state: MonsterViewControllerState)
    func setTrackingStatus(_ status: String)
    func updateStatus()
    func setFocusPoint(_ coordinate: CGPoint)
    func setAnnotationView()
    func action()
    func createPokeBall() -> SCNNode?
}

// MARK: - ViewController State Management

enum MonsterViewControllerState: Int16 {
    case DetectSurface
    case PointAtSurface
    case TapToStart
    case Started
    case MonsterCatched
}

class MonsterPresenter: MonsterPresenterProtocol {
    
    
    
    //MARK: - Properties
    weak var view: MonsterViewProtocol?
    weak var monster: MonsterModelProtocol?
    var router: RouterProtocol
    
    var trackingStatus: String = ""
    var statusMessage: String = ""
    var vcState: MonsterViewControllerState = .DetectSurface
    var focusPoint:CGPoint!
        
    //MARK: - Initializer
    required init(view: MonsterViewProtocol, monster: MonsterModelProtocol, router: RouterProtocol) {
        self.view = view
        self.monster = monster
        self.router = router
    }
    
    //MARK: - Methods
    func createScene() -> ModelScene? {
        guard let monster = monster else { return nil }
        return ModelScene(named: monster.imageName)
    }
    
    func goToRootVC() {
        router.popToRoot()
    }
    
    //Set vcState
    func setVCState(_ state: MonsterViewControllerState) {
        vcState = state
    }
    
    //Set trackingStatus
    func setTrackingStatus(_ status: String) {
        self.trackingStatus = status
    }
    
    //Update statusMessage
    func updateStatus() {
        
        switch vcState {
        
        case .DetectSurface:
            statusMessage = "Сканирование доступных плоских поверхностей..."
        case .PointAtSurface:
            statusMessage = "Сначала наведите камеру на поверхность!"
        case .TapToStart:
            statusMessage = "Tap to start."
        case .Started:
            statusMessage = "Поймайте монстра!"
        case .MonsterCatched:
            statusMessage = "Ура, вы поймали монстра!"
        }
        
        view?.setStatusLabelText(trackingStatus: trackingStatus, statusMessage: statusMessage)
    }
    
    //Setup focusPoint
    func setFocusPoint(_ coordinate: CGPoint) {
        self.focusPoint = coordinate
    }
    
    //Set annotation view
    
    func setAnnotationView() {
        
        guard let monster = monster else { return }
        
        switch vcState {
        
        case .Started:
            
            view?.setAnnotationLabelTextCaseMonster(monsterName: monster.name,
                                                    monsterLevel: String(monster.level))
        
            
        default:
            break
        }
    }
    
    //Set action on action button tapped
    
    func action() {
        
        switch vcState {
        
        case .Started:
            view?.launchPokeBall()
            
        case .MonsterCatched:
            goToRootVC()
            
        default:
            break
        }
    }
    
    func createPokeBall() -> SCNNode? {
        
        guard let ballScene = ModelScene(named: "pokeball"), let ballNode = ballScene.node else { return nil }
        
        return ballNode
        
    }
    
    
}
