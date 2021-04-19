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
            .bind(to: tableView.rx.items(cellIdentifier: "SearchResultCell")) { (index, searchResult, cell) in
                cell.textLabel?.text = searchResult.trackName
            }.disposed(by: disposeBag)
    }
}

