//
//  MonsterViewControllerTests.swift
//  MonstersTests
//
//  Created by Maxim Alekseev on 23.01.2021.
//

import XCTest
import CoreLocation
import ARKit
import SceneKit
@testable import Monsters

private class MockMonsterPresenter: MonsterPresenterProtocol {
    
    weak var view: MonsterViewProtocol?
    
    var monster: MonsterModelProtocol?
    
    var router: RouterProtocol
    
    var trackingStatus: String = ""
     
    var statusMessage: String = ""
    
    var vcState: MonsterViewControllerState = .DetectSurface
    
    var focusPoint: CGPoint!
    
    var testAction: String?
    
    required init(view: MonsterViewProtocol, monster: MonsterModelProtocol, router: RouterProtocol) {
        self.view = view
        self.monster = monster
        self.router = router
    }
    
    func createScene() -> ModelScene? {
        return nil
    }
    
    func goToRootVC(_ monster: MonsterModelProtocol?) {
        
    }
    
    func setVCState(_ state: MonsterViewControllerState) {
        self.vcState = state
    }
    
    func setTrackingStatus(_ status: String) {
        
    }
    
    func updateStatus() {
        
    }
    
    func setFocusPoint(_ coordinate: CGPoint) {
        
    }
    
    func setAnnotationView() {
        
    }
    
    func action() {
        
        switch vcState {
        
        case .Started:
            self.testAction = "Started"
                
        case .MonsterCatched:
            self.testAction = "MonsterCatched"
            
        case .Loosed:
            self.testAction = "Loosed"
            
        default:
            break
        }

        
    }
    
    func createPokeBall() -> SCNNode? {
        return nil
    }
    
    func storeMonster() {
        
    }
    
    
}

class MonsterViewControllerTests: XCTestCase {
    
    var view: MonsterViewController!
    fileprivate var presenter: MockMonsterPresenter!
    
    override func setUpWithError() throws {
        
        view = MonsterViewController()
        let monster = Monster(name: "Altair",
                              imageName: "altair",
                              level: 1,
                              coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0) )
        let router = Router(navigationController: UINavigationController(), assemblyBuilder: AssemblyBuilder())
        
        presenter = MockMonsterPresenter(view: view,
                                              monster: monster,
                                              router: router)
        view.presenter = presenter
    }

    override func tearDownWithError() throws {
        presenter = nil
        view = nil
    }
    
        
    func testActionButtonTapped() {
        
        view.loadView()
        presenter.vcState = .Started
        
        //First tap
        view.actionButtonTapped(UIButton())
        XCTAssertEqual(view.numberAttempts, 1)
        XCTAssertEqual(view.attemptThreeImage.alpha, 0)
        XCTAssertEqual(presenter.testAction, "Started")
        
        //Second tap
        view.actionButtonTapped(UIButton())
        XCTAssertEqual(view.numberAttempts, 2)
        XCTAssertEqual(view.attemptTwoImage.alpha, 0)
        XCTAssertEqual(presenter.testAction, "Started")
        
        //Third tap
        view.actionButtonTapped(UIButton())
        XCTAssertEqual(view.numberAttempts, 3)
        XCTAssertEqual(view.attemptOneImage.alpha, 0)
        XCTAssertEqual(presenter.testAction, "Started")
        
        //Fourth tap
        view.actionButtonTapped(UIButton())
        XCTAssertTrue(view.resetButton.isHidden)
        XCTAssertTrue(view.attemptsStackView.isHidden)
        XCTAssertEqual(presenter.vcState, .Loosed)
        
        //Fifth tap
        view.actionButtonTapped(UIButton())
        XCTAssertEqual(presenter.testAction, "Loosed")
    }
    
    func testSetAnnotationLabelTextCaseMonster() {
        view.loadView()
        view.setAnnotationLabelTextCaseMonster(monsterName: "Foo", monsterLevel: "Bar")
        
        XCTAssertFalse(view.annotationView.isHidden)
        XCTAssertEqual(view.annotationLabel.text, "Foo,\nуровень: Bar")
    }
    
    func testsetStatusLabelText() {
        view.loadView()
        view.setStatusLabelText(trackingStatus: "Foo", statusMessage: "Bar")
        XCTAssertEqual(view.statusLabel.text, "Foo")
        view.setStatusLabelText(trackingStatus: "", statusMessage: "Bar")
        XCTAssertEqual(view.statusLabel.text, "Bar")
    }
    
}
