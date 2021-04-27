//
//  DetailViewController.swift
//  RxSwiftAppStoreAPI
//
//  Created by TaeWon Seo on 2021/04/21.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var playButton: UIButton!
    
    private var player: AVPlayer = AVPlayer()
    private var isPlay = false
    private let disposeBag = DisposeBag()
    
    var searchResult: MusicSearchResult?
    
    static func instantiate(searchResult: MusicSearchResult) -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else { return DetailViewController() }
        viewController.searchResult = searchResult
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard let searchResult = searchResult else { return }
        navigationItem.title = searchResult.trackName
        
        guard let musicURL = URL(string: searchResult.previewUrl) else{ return }
        let item = AVPlayerItem(url: musicURL)
        player.replaceCurrentItem(with: item)
        
        bindUI()
        
        guard let imageURL = URL(string: searchResult.artworkUrl100) else { return }
        albumImageView.kf.setImage(with: imageURL)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func bindUI() {
        playButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.tapPlayButton()
            }).disposed(by: disposeBag)
    }
    
    private func tapPlayButton() {
        if isPlay {
            player.pause()
            playButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlay = false
        } else {
            player.play()
            playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            isPlay = true
        }
    }
}
