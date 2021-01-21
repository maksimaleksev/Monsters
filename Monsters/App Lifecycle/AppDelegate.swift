//
//  AppDelegate.swift
//  Monsters
//
//  Created by Maxim Alekseev on 02.01.2021.
//

import UIKit

protocol AppDelegateProtocol: class {
    func appDidBecomeActive()
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    weak var delegate: AppDelegateProtocol?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let assemblyBuilder = AssemblyBuilder()
        let router = Router(navigationController: navigationController, assemblyBuilder: assemblyBuilder)
        router.initialViewController()
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        delegate?.appDidBecomeActive()
    }
}

