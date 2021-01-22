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
    func goToRootVC(_ monster: MonsterModelProtocol?)
    func setVCState(_ state: MonsterViewControllerState)
    func setTrackingStatus(_ status: String)
    func updateStatus()
    func setFocusPoint(_ coordinate: CGPoint)
    func setAnnotationView()
    func action()
    func createPokeBall() -> SCNNode?
    func storeMonster()
}

// MARK: - For MonsterViewController State Management

enum MonsterViewControllerState: Int16 {
    case DetectSurface
    case PointAtSurface
    case Started
    case MonsterCatched
    case Loosed
}

//MARK: - MonsterPresenter Class

class MonsterPresenter: MonsterPresenterProtocol {
        
    //MARK: - Properties
    weak var view: MonsterViewProtocol?
    var monster: MonsterModelProtocol?
    unowned var router: RouterProtocol
    
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
    
    deinit {
        print(String(describing: MonsterPresenter.self) + " deinit")
    }
    
    //MARK: - Methods
    
    //Creating Scene 
    func createScene() -> ModelScene? {
        guard let monster = monster else { return nil }
        return ModelScene(named: monster.imageName)
    }
    
    //Return to mapVC
    func goToRootVC(_ monster: MonsterModelProtocol?) {
        
        guard let monster = monster  else {
            router.popToMapViewController(.Loose)
            return
        }
        
        router.popToMapViewController(.Monster(monster))
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
        case .Started:
            statusMessage = "Поймайте монстра!"
        case .MonsterCatched:
            statusMessage = "Ура, вы поймали монстра!"
        case .Loosed:
            statusMessage = "Монстр скрылся, попробуйте в следующий раз!"
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
    
    //Set action on button tapped
    
    func action() {
        
        switch vcState {
        
        case .Started:
            view?.launchPokeBall()
            
        case .MonsterCatched:
            storeMonster()
            goToRootVC(self.monster)
            
        case .Loosed:
            goToRootVC(nil)
            
        default:
            break
        }
    }
    
    //CreatePokeBall node
    
    func createPokeBall() -> SCNNode? {
        
        guard let ballScene = ModelScene(named: "pokeball"), let ballNode = ballScene.node else { return nil }
        
        return ballNode
        
    }
    
    //Store Monster in UserDefaults
    
    func storeMonster() {
        
        guard let monster = monster as? Monster else { return }
        
        let teamedMonster = TeamedMonsterModel(name: monster.name, imageName: monster.imageName, level: monster.level)
        
        let defaults = UserDefaults.standard
        var monsterList = defaults.savedMonsters()
        
        monsterList.append(teamedMonster)
        
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: monsterList, requiringSecureCoding: false) {
            defaults.set(savedData, forKey: UserDefaults.monsterTeam)
        }
    }

}
