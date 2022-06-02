//
//  NewsListViewController.swift
//  CodingTest
//
//  Created by Chung Cr on 31/05/2022.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var viewModel: NewsListViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.input.startRequestDefaultNews.onNext(())
    }
    
    private func setupViews() {
        self.title = "News"
        self.tableView.register(nib: NewsListCell.self)
    }
    
    private func bindViewModel() {
        guard self.viewModel != nil else { return }
        
        self.searchBar.rx.text.orEmpty
            .map({ $0.trimmingCharacters(in: .whitespaces) })
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                if !text.isEmpty {
                    self?.viewModel.input.startRequestNewsList.onNext(text)
                } else {
                    self?.viewModel.input.startRequestDefaultNews.onNext(())
                }
            }).disposed(by: disposeBag)
        
        viewModel.output.displayNewsList
            .bind(to: tableView.rx.items(cellIdentifier: NewsListCell.identifier, cellType: NewsListCell.self)) { index, displayModel, cell in
                cell.updateDisplay(displayModel)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            self?.viewModel.input.onSelectNews.onNext(indexPath)
        }).disposed(by: disposeBag)

        tableView.rx.willDisplayCell.subscribe(onNext: { [weak self] event in
            guard let self = self, self.viewModel.canLoadMore else { return }
            if event.indexPath.row == self.viewModel.numberOfDisplayingItems - 1 {
                self.viewModel.input.onLoadMoreNews.onNext(())
            }
        }).disposed(by: disposeBag)
    }
}

// MARK: - UISearchBarDelegate
extension NewsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
