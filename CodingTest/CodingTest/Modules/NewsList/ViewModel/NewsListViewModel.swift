//
//  NewsListViewModel.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import RxSwift
import PKHUD
import Alamofire

class NewsListViewModel {
    
    struct Input {
        let startRequestNewsList: AnyObserver<String>
        let onSelectNews: AnyObserver<IndexPath>
    }
    
    struct Output {
        let displayNewsList: Observable<[NewsListDisplayModel]>
        let onNavigateToNewsDetail: Observable<String>
    }
    
    private let onRequestNewsList = PublishSubject<String>()
    private let onDisplayNewsList = BehaviorSubject<[NewsListDisplayModel]>(value: [])
    private let onSelectNewsDetail = PublishSubject<IndexPath>()
    private let onNavigateToNewsDetail = PublishSubject<String>()
    
    private var requestPage: Int = 1
    private let pageSize = 20
    
    private var newsArticles: [NewsArticle] = []

    private let disposeBag = DisposeBag()
    
    let input: Input
    let output: Output
    
    init() {
        self.input = Input(startRequestNewsList: onRequestNewsList.asObserver(),
                           onSelectNews: onSelectNewsDetail.asObserver())
        
        self.output = Output(displayNewsList: onDisplayNewsList.asObservable(),
                             onNavigateToNewsDetail: onNavigateToNewsDetail.asObservable())
        
        self.config()
    }
    
    private func config() {
        onRequestNewsList.subscribe(onNext: { [weak self] in
            self?.loadNewsList(searchText: $0)
        }).disposed(by: disposeBag)
        
        onSelectNewsDetail.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard self.newsArticles.count > indexPath.row else { return }
            let url = self.newsArticles[indexPath.row].url
            self.onNavigateToNewsDetail.onNext(url)
        }).disposed(by: disposeBag)
    }
    
    private func loadNewsList(searchText: String) {
        PKHUD.sharedHUD.show()
        let params: Parameters = ["q": searchText, "page": self.requestPage, "pageSize": self.pageSize]
        
        GetNewsListRequest.shared.request(param: params)
            .subscribe(onNext: { [weak self] response in
                PKHUD.sharedHUD.hide()
                guard let self = self, let allArticles = response.articles else {
                    self?.newsArticles.removeAll()
                    self?.onDisplayNewsList.onNext([])
                    return
                }
                
                self.newsArticles = allArticles
                self.onDisplayNewsList.onNext(self.newsArticles.map({ article in
                    return NewsListDisplayModel(title: article.title,
                                                updatedTime: article.publishedAt,
                                                imageURL: article.urlToImage,
                                                description: article.description)
                }))
            }, onError: { error in
                PKHUD.sharedHUD.hide()
                // TODO: Display error
                print("Error: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
}
