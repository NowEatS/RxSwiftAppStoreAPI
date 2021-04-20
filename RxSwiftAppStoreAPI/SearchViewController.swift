//
//  SearchViewController.swift
//  RxSwiftAppStoreAPI
//
//  Created by TaeWon Seo on 2021/04/19.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    let searchViewModel = SearchViewModel()
    
    let disposeBag = DisposeBag()
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        bindUI()
    }
    
    private func configureSearchController() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        searchBar.showsCancelButton = true
        searchBar.placeholder = "가수 이름 검색"
        searchBar.rx.text.orEmpty.distinctUntilChanged()
            .subscribe(onNext: { keyword in
                self.searchViewModel.setSearchKeyword(keyword)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        searchViewModel.listObservable.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "SearchResultListCell")) { (index, searchResult, cell) in
                guard let cell = cell as? SearchResultListCell else { return }
                cell.setUpContents(searchResult)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(MusicSearchResult.self)
            .subscribe(onNext: { model in
                let detailVC = DetailViewController.instantiate(searchResult: model)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }).disposed(by: disposeBag)
    }
}

