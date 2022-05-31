//
//  NewsDetailCoordinator.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import RxSwift

class NewsDetailCoordinator: BaseCoordinator<Void> {
    
    private let rootViewController: UIViewController
    var viewModel: NewsDetailViewModel!
    
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        let viewController = NewsDetailViewController.initFromNib()
        viewController.viewModel = self.viewModel
        
        rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return Observable.never()
    }
}
