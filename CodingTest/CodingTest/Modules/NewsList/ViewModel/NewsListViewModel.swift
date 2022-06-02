//
//  NewsListViewModel.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import RxSwift
import SVProgressHUD
import Alamofire

class NewsListViewModel {
    
    struct Input {
        let startRequestDefaultNews: AnyObserver<Void>
        let startRequestNewsList: AnyObserver<String>
        let onSelectNews: AnyObserver<IndexPath>
        let onLoadMoreNews: AnyObserver<Void>
    }
    
    struct Output {
        let displayNewsList: Observable<[NewsListDisplayModel]>
        let onNavigateToNewsDetail: Observable<String>
    }
    
    private let disposeBag = DisposeBag()
    
    private let onRequestDefaultNews = PublishSubject<Void>()
    private let onRequestNewsList = PublishSubject<String>()
    private let onDisplayNewsList = BehaviorSubject<[NewsListDisplayModel]>(value: [])
    private let onSelectNewsDetail = PublishSubject<IndexPath>()
    private let onNavigateToNewsDetail = PublishSubject<String>()
    private let onLoadMoreNews = PublishSubject<Void>()
    
    private var currentSearchText: String?
    private var requestPage: Int = 1
    private let pageSize = 20
    private var totalResults: Int = 0
    private var isLoading: Bool = false
    
    private var newsArticles: [NewsArticle] = []
    var numberOfDisplayingItems: Int {
        return newsArticles.count
    }

    var canLoadMore: Bool {
        return totalResults > numberOfDisplayingItems
    }
    
    let input: Input
    let output: Output
    
    init() {
        self.input = Input(startRequestDefaultNews: onRequestDefaultNews.asObserver(),
                           startRequestNewsList: onRequestNewsList.asObserver(),
                           onSelectNews: onSelectNewsDetail.asObserver(),
                           onLoadMoreNews: onLoadMoreNews.asObserver())
        
        self.output = Output(displayNewsList: onDisplayNewsList.asObservable(),
                             onNavigateToNewsDetail: onNavigateToNewsDetail.asObservable())
        
        self.config()
    }
    
    private func config() {
        onRequestDefaultNews.subscribe(onNext: { [weak self] in
            self?.loadDefaultNews()
        }).disposed(by: disposeBag)
        
        onRequestNewsList.subscribe(onNext: { [weak self] in
            self?.loadNewsList(searchText: $0)
        }).disposed(by: disposeBag)
        
        onLoadMoreNews.subscribe(onNext: { [weak self] in
            self?.loadMoreNews()
        }).disposed(by: disposeBag)
        
        onSelectNewsDetail.subscribe(onNext: { [weak self] indexPath in
            guard let self = self else { return }
            guard self.newsArticles.count > indexPath.row else { return }
            if let url = self.newsArticles[indexPath.row].url {
                self.onNavigateToNewsDetail.onNext(url)
            }
        }).disposed(by: disposeBag)
    }
    
    private func loadNewsList(searchText: String, isLoadingMore: Bool = false) {
        guard !self.isLoading else { return }
        SVProgressHUD.show()
        self.isLoading = true
        self.currentSearchText = searchText
        let params: Parameters = [ParameterKey.q: searchText,
                                  ParameterKey.page: self.requestPage,
                                  ParameterKey.pageSize: self.pageSize]
        
        GetNewsListRequest.shared.request(param: params)
            .subscribe(onNext: { [weak self] response in
                SVProgressHUD.dismiss()
                self?.isLoading = false
                guard let self = self, let allArticles = response.articles else {
                    self?.handleRequestFailure(isLoadingMore: isLoadingMore)
                    return
                }
                
                if !isLoadingMore {
                    self.newsArticles.removeAll()
                }
                self.newsArticles.append(contentsOf: allArticles)
                self.totalResults = response.totalResults ?? 0
                self.onDisplayNewsList.onNext(self.newsArticles.map({ article in
                    return NewsListDisplayModel(title: article.title ?? "",
                                                updatedTime: article.publishedAt ?? "",
                                                imageURL: article.urlToImage,
                                                description: article.description ?? "")
                }))
            }, onError: { [weak self] error in
                SVProgressHUD.dismiss()
                self?.isLoading = false
                if isLoadingMore {
                    self?.requestPage -= 1
                }
                // TODO: Display error
                print("Error: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    private func loadMoreNews() {
        guard self.canLoadMore, !self.isLoading else { return }
        self.requestPage += 1
        
        if let searchText = self.currentSearchText {
            self.loadNewsList(searchText: searchText, isLoadingMore: true)
        } else {
            self.loadDefaultNews(isLoadingMore: true)
        }
    }
    
    private func loadDefaultNews(isLoadingMore: Bool = false) {
        guard !self.isLoading else { return }
        SVProgressHUD.show()
        self.isLoading = true
        self.currentSearchText = nil
        let params: Parameters = [ParameterKey.page: self.requestPage,
                                  ParameterKey.pageSize: self.pageSize]
        
        GetTopHeadlinesRequest.shared.request(param: params)
            .subscribe(onNext: { [weak self] response in
                SVProgressHUD.dismiss()
                self?.isLoading = false
                guard let self = self, let articles = response.articles else {
                    self?.handleRequestFailure(isLoadingMore: isLoadingMore)
                    return
                }
                if !isLoadingMore {
                    self.newsArticles.removeAll()
                }
                self.newsArticles.append(contentsOf: articles)
                self.totalResults = response.totalResults ?? 0
                self.onDisplayNewsList.onNext(self.newsArticles.map({ article in
                    return NewsListDisplayModel(title: article.title ?? "",
                                                updatedTime: article.publishedAt ?? "",
                                                imageURL: article.urlToImage,
                                                description: article.description ?? "")
                }))
            }, onError: { [weak self] error in
                SVProgressHUD.dismiss()
                self?.isLoading = false
                if isLoadingMore {
                    self?.requestPage -= 1
                }
                // TODO: Display error
                print("Error: \(error.localizedDescription)")
            }).disposed(by: disposeBag)
    }
    
    private func handleRequestFailure(isLoadingMore: Bool = false) {
        if !isLoadingMore {
            self.requestPage = 1
            self.totalResults = 0
            self.newsArticles.removeAll()
            self.onDisplayNewsList.onNext([])
        } else {
            self.requestPage -= 1
        }
    }
}
