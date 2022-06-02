//
//  NewsDetailViewController.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import UIKit
import RxSwift
import WebKit
import SVProgressHUD

class NewsDetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: NewsDetailViewModel!

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.bindViewModel()
        self.viewModel.input.onStartLoadNewsDetail.onNext(())
    }
    
    private func setupViews() {
        self.title = "Details"
        self.webview.navigationDelegate = self
    }

    private func bindViewModel() {
        guard self.viewModel != nil else { return }
        viewModel.output.onDisplayNewsDetail.subscribe(onNext: { [weak self] url in
            SVProgressHUD.show()
            let request = URLRequest(url: url)
            self?.webview.load(request)
        }).disposed(by: disposeBag)
    }
}

// MARK: - WKNavigationDelegate
extension NewsDetailViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        SVProgressHUD.dismiss()
    }
}
