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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
    }
    
    private func setupViews() {
        self.title = "News"
        self.tableView.register(nib: NewsListCell.self)
    }
    
    private func bindViewModel() {
        guard self.viewModel != nil else { return }
        viewModel.output.displayNewsList
            .bind(to: tableView.rx.items(cellIdentifier: NewsListCell.identifier, cellType: NewsListCell.self)) { index, displayModel, cell in
                cell.updateDisplay(displayModel)
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            self?.viewModel.input.onSelectNews.onNext(indexPath)
        }).disposed(by: disposeBag)

    }
}

// MARK: - UISearchBarDelegate
extension NewsListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        searchBar.resignFirstResponder()
        self.viewModel.input.startRequestNewsList.onNext(text)
    }
}
