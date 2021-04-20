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
    
    private var player: AVAudioPlayer?
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
        
        do {
            player = try AVAudioPlayer(contentsOf: musicURL)
            bindUI()
        } catch {
            print("플레이어 생성 실패")
        }
        
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
        guard let player = player else { return }
        if player.isPlaying {
            player.stop()
            playButton.setImage(UIImage(named: "play.fill"), for: .normal)
        } else {
            player.play()
            playButton.setImage(UIImage(named: "pause.fill"), for: .normal)
        }
    }
}
