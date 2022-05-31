//
//  NewsListCoordinator.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import UIKit
import RxSwift

class NewsListCoordinator: BaseCoordinator<Void> {
    let rootViewController: UIViewController
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    override func start() -> Observable<Void> {
        guard let newsListViewController = rootViewController as? NewsListViewController else { return Observable.never() }
        let newsListViewModel = NewsListViewModel()
        
        newsListViewController.viewModel = newsListViewModel
        newsListViewModel.output.onNavigateToNewsDetail.map { url in
            return NewsDetailViewModel(urlString: url)
        }.subscribe(onNext: { [unowned self] viewModel in
            self.coordinatorToDetail(with: viewModel)
                .subscribe()
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
        
        return Observable.never()
    }
    
    private func coordinatorToDetail(with viewModel: NewsDetailViewModel) -> Observable<Void> {
        let detailCoordinator = NewsDetailCoordinator(rootViewController: rootViewController)
        detailCoordinator.viewModel = viewModel
        return coordinate(to: detailCoordinator).map({ () })
    }
}
