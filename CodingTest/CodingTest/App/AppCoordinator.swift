//
//  AppCoordinator.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import UIKit
import RxSwift

class AppCoordinator: BaseCoordinator<Void> {
    
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        let navigationController = UINavigationController(rootViewController: NewsListViewController.initFromNib())
        navigationController.navigationBar.tintColor = UIColor(red: 55/255, green: 157/255, blue: 200/255, alpha: 1)
        navigationController.navigationBar.barTintColor = UIColor(red: 55/255, green: 157/255, blue: 200/255, alpha: 1)
        let newsListCoordinator = NewsListCoordinator(rootViewController: navigationController.viewControllers.first!)
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
        return self.coordinate(to: newsListCoordinator)
    }
}
