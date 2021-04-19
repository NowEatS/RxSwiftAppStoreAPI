//
//  SearchViewModel.swift
//  RxSwiftAppStoreAPI
//
//  Created by TaeWon Seo on 2021/04/20.
//

import Foundation
import RxSwift

class SearchViewModel {
    private var list: PublishSubject<[MusicSearchResult]> = PublishSubject<[MusicSearchResult]>()
    
    let disposeBag = DisposeBag()
    
    var listObservable: Observable<[MusicSearchResult]> {
        return list.asObservable()
    }
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask? = nil
    
    func setSearchKeyword(_ keyword: String) {
        requestSearch(keyword)
    }
    
    private func requestSearch(_ keyword: String) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://itunes.apple.com/search") {
            urlComponents.query = "media=music&entity=song&term=\(keyword)"
            
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.dataTask = nil
                }
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    
                    do {
                        let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                        self?.list.onNext(searchResult.results)
                    } catch {
                        print("디코딩 실패")
                    }
                }
            }
            
            dataTask?.resume()
        }
    }
}
