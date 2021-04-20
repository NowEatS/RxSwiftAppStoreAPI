//
//  SearchResultListCell.swift
//  RxSwiftAppStoreAPI
//
//  Created by TaeWon Seo on 2021/04/21.
//

import UIKit
import Kingfisher

class SearchResultListCell: UITableViewCell {
    
    @IBOutlet private var albumImageView: UIImageView!
    @IBOutlet private var songNameLabel: UILabel!
    @IBOutlet private var artistNameLabel: UILabel!
    
    private var musicSearchResult: MusicSearchResult?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumImageView.image = nil
        songNameLabel.text = ""
        artistNameLabel.text = ""
    }
    
    func setUpContents(_ searchResult: MusicSearchResult) {
        DispatchQueue.main.async {
            self.musicSearchResult = searchResult
            
            if let url = URL(string: searchResult.artworkUrl60) {
                self.albumImageView.kf.setImage(with: url)
            }
            self.songNameLabel.text = searchResult.trackName
            self.artistNameLabel.text = searchResult.artistName
        }
    }
}
