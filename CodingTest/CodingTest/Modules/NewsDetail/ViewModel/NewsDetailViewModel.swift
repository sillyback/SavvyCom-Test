//
//  NewsDetailViewModel.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import Foundation
import RxSwift

class NewsDetailViewModel {
    
    struct Input {
        let onStartLoadNewsDetail: AnyObserver<Void>
    }
    struct Output {
        let onDisplayNewsDetail: Observable<URL>
    }
    
    private let onDisplayWebContent = PublishSubject<URL>()
    private let onStartLoadNewsDetail = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
    private let urlString: String
    let input: Input
    let output: Output
    
    init(urlString: String) {
        self.urlString = urlString
        self.input = Input(onStartLoadNewsDetail: onStartLoadNewsDetail.asObserver())
        self.output = Output(onDisplayNewsDetail: onDisplayWebContent.asObservable())
        
        config()
    }
    
    private func config() {
        self.onStartLoadNewsDetail.subscribe(onNext: { [weak self] in
            guard let urlString = self?.urlString, let url = URL(string: urlString) else { return }
            self?.onDisplayWebContent.onNext(url)
        }).disposed(by: disposeBag)
    }
}
