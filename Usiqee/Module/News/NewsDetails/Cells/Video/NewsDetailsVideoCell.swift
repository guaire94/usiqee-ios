//
//  NewsDetailsVideoCell.swift
//  Usiqee
//
//  Created by Amine on 07/07/2021.
//

import UIKit
import youtube_ios_player_helper

class NewsDetailsVideoCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsDetailsVideoCell"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var videoPlayer: YTPlayerView!
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var videoId: String?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(videoId: String) {
        guard self.videoId != videoId else {
            return
        }
        self.videoId = videoId
        loader.isHidden = false
        loader.startAnimating()
        videoPlayer.delegate = self
        videoPlayer.load(withVideoId: videoId)
    }
}

// MARK: - YTPlayerViewDelegate
extension NewsDetailsVideoCell: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        loader.isHidden = true
    }
}
