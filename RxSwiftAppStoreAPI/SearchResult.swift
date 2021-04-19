//
//  SearchResult.swift
//  RxSwiftAppStoreAPI
//
//  Created by TaeWon Seo on 2021/04/20.
//

import Foundation

struct SearchResults: Decodable {
    let resultCount: Int
    let results: [MusicSearchResult]
    
//    var isDownloading = false
//    var progress: Float = 0
//    var resumeData: Data?
//    var task: URLSessionDownloadTask?
//    var track: Track
//
//    init(track: Track) {
//        self.track = track
//    }
}

struct MusicSearchResult: Decodable {
    let trackName: String
    let artistName: String
    let collectionName: String
    let artworkUrl60: String
    let artworkUrl100: String
    let previewUrl: String
    let isStreamable: Bool
}
