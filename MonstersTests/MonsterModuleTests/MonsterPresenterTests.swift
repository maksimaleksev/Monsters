//
//  MonsterPresenterTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 17.01.2021.
//

import XCTest
import CoreLocation
@testable import Monsters

fileprivate class MockMonsterRouter: RouterProtocol {
    
    var navigationController: UINavigationController?
    
    var assemblyBuilder: AssemblyBuilderProtocol?
    
    var mapPresenter: MapPresenterProtocol?
    
    var segueTest: String?
    
    required init(navigationController: UINavigationController, assemblyBuilder: AssemblyBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        
    }
    
    func showMonsterModule(_ monster: MonsterModelProtocol) {
        
    }
    
    func popToMapViewController(_ segueCase: SegueCases) {
        switch segueCase {
        
        case .Monster(_):
            segueTest = "Foo"
        case .Loose:
            segueTest = "Bar"
        }
    }
    
    func showMonstersTeamModule() {
        
    }
    
}

fileprivate class MockMonsterView: MonsterViewProtocol {
    
    var presenter: MonsterPresenterProtocol!
    var annotationText: String?
    var testLaunchPokeball: String?
    
    func setStatusLabelText(trackingStatus: String, statusMessage: String) {
        
    }
    
    func setAnnotationLabelTextCaseMonster(monsterName: String, monsterLevel: String) {
        self.annotationText = "Name: \(monsterName), level: \(monsterLevel)"
    }
    
    func launchPokeBall() {
        self.testLaunchPokeball = "Pokeball launched"
    }
    
    func setupAfter(monsterCatched: MonsterViewControllerState) {
        
    }
    
}


class MonsterPresenterTests: XCTestCase {
    
    var presenter: MonsterPresenter!
    fileprivate var view: MockMonsterView!
    
    override func setUpWithError() throws {
        view = MockMonsterView()
        
        let monster = Monster(name: "Altair",
                              imageName: "altair",
                              level: 1,
                              coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        let router = MockMonsterRouter(navigationController: UINavigationController(),
                                       assemblyBuilder: AssemblyBuilder())
        presenter = MonsterPresenter(view: view, monster: monster, router: router)
        view.presenter = presenter
    }
    
    override func tearDownWithError() throws {
        
        presenter = nil
        let defaults = UserDefaults.standard
        var monsterList = defaults.savedMonsters()
        if let i = monsterList.firstIndex(where: { $0.name == "Foo" }) {
            monsterList.remove(at: i)
            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: monsterList, requiringSecureCoding: false) {
                defaults.set(savedData, forKey: UserDefaults.monsterTeam)
            }
        }
    }
    
    //Creating Scene test
    
    func testCreateModelScene() {
        let monster = Monster(name: "Altair",
                              imageName: "altair",
                              level: 1,
                              coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        presenter.monster = monster
        let modelScene = presenter.createScene()
        XCTAssertNotNil(modelScene)
    }
    
    //Return to mapVC
    
    func testGoToRootVC() {
        
        let mockRouter = MockMonsterRouter(navigationController: UINavigationController(),
                                           assemblyBuilder: AssemblyBuilder())
        
        presenter.router = mockRouter
        
        //Case monster loose
        presenter.goToRootVC(nil)
        
        let router = presenter.router as! MockMonsterRouter
        
        XCTAssertEqual(router.segueTest, "Bar")
        
        //Case monster
        
        let monster = Monster(name: "Foo",
                              imageName: "foo",
                              level: 1,
                              coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        presenter.goToRootVC(monster)
        
        XCTAssertEqual(router.segueTest, "Foo")
        
    }
    
    //Set vcState test
    
    func testSetVCState() {
        presenter.setVCState(.Loosed)
        XCTAssertEqual(presenter.vcState, .Loosed)
    }
    
    //SetTrackingStatus test
    
    func testSetTrackingStatus() {
        presenter.setTrackingStatus("Foo")
        XCTAssertEqual(presenter.trackingStatus, "Foo")
    }
    
    //Update statusMessage tests
    
    func testUpdateStatus() {
        
        //Case .DetectSurface
        presenter.vcState = .DetectSurface
        presenter.updateStatus()
        XCTAssertEqual(presenter.statusMessage, "Сканирование доступных плоских поверхностей...")
        
        //Case .PointAtSurface
        presenter.vcState = .PointAtSurface
        presenter.updateStatus()
        XCTAssertEqual(presenter.statusMessage, "Сначала наведите камеру на поверхность!")
        
        //Case .Started
        presenter.vcState = .Started
        presenter.updateStatus()
        XCTAssertEqual(presenter.statusMessage, "Поймайте монстра!")
        
        //Case .MonsterCatched
        presenter.vcState = .MonsterCatched
        presenter.updateStatus()
        XCTAssertEqual(presenter.statusMessage, "Ура, вы поймали монстра!")
        
        //Case .Loosed
        presenter.vcState = .Loosed
        presenter.updateStatus()
        XCTAssertEqual(presenter.statusMessage, "Монстр скрылся, попробуйте в следующий раз!")
    }
    
    //Setup focusPoint tests
    
    func testSetFocusPoint() {
        
        let point = CGPoint(x: 1, y: 1)
        presenter.setFocusPoint(point)
        XCTAssertEqual(presenter.focusPoint, point)
        
    }
    
    //Set annotation view tests
    func testSetAnnotationView() {
        
        presenter.vcState = .Started
        presenter.monster = Monster(name: "Foo", imageName: "foo", level: 1, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        presenter.setAnnotationView()
        
        XCTAssertEqual(view.annotationText, "Name: Foo, level: 1")
    }
    
    //Set action on button tapped
    
    func testAction() {
        
        presenter.monster = Monster(name: "Foo", imageName: "foo", level: 1, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        
        //Case .Started
        presenter.vcState = .Started
        presenter.action()
        XCTAssertEqual(view.testLaunchPokeball, "Pokeball launched")
        
        //Case .MonsterCatched
        
        let mockRouter = MockMonsterRouter(navigationController: UINavigationController(),
                                           assemblyBuilder: AssemblyBuilder())
        
        presenter.router = mockRouter
        let router = presenter.router as! MockMonsterRouter
        presenter.vcState = .MonsterCatched
        presenter.action()
        XCTAssertEqual(router.segueTest, "Foo")
        
        //Case .Loosed
        presenter.vcState = .Loosed
        presenter.action()
        XCTAssertEqual(router.segueTest, "Bar")
    }
    
    //CreatePokeBall node tests
    
    func testCreatePokeBall() {
        let node = presenter.createPokeBall()
        XCTAssertEqual(node?.name, "PokeBall")
    }
    
    //Store Monster in UserDefaults
    
    func testStoreMonster() {
        presenter.monster = Monster(name: "Foo", imageName: "foo", level: 1, coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        presenter.storeMonster()
        
        let defaults = UserDefaults.standard
        let monsterList = defaults.savedMonsters()
        
        XCTAssertNotNil(monsterList.firstIndex(where: { $0.name == "Foo" }))
    }
    
    
}

