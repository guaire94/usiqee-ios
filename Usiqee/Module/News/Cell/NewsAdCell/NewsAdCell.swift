//
//  NewsAdCell.swift
//  Usiqee
//
//  Created by Amine on 12/08/2021.
//

import UIKit
import GoogleMobileAds

class NewsAdCell: UITableViewCell {
    
    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 136
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsAdCell"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var adsContent: UIView!
    @IBOutlet weak private var nativeAdView: GADUnifiedNativeAdView!
    @IBOutlet weak private var loader: UIActivityIndicatorView!
    
    // MARK: - Properties
    private var adLoader: GADAdLoader?
    
    private var headlineView: UILabel? {
        nativeAdView.headlineView as? UILabel
    }
    private var bodyView: UILabel? {
        nativeAdView.bodyView as? UILabel
    }
    private var advertiserView: UILabel? {
        nativeAdView.advertiserView as? UILabel
    }
    private var iconView: UIImageView? {
        nativeAdView.iconView as? UIImageView
    }
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configure() {
        guard adLoader == nil else { return }
        loader.isHidden = false
        loader.startAnimating()
        adLoader = GADAdLoader(
            adUnitID: Config.adUnitId, rootViewController: UIApplication.shared.keyWindow?.rootViewController,
            adTypes: [.unifiedNative], options: nil)
        adLoader?.delegate = self
        adLoader?.load(GADRequest())
    }
    
    // MARK: - Private
    private func setupView() {
        headlineView?.font = Fonts.NewsDetails.Ads.headline
        bodyView?.font = Fonts.NewsDetails.Ads.body
        advertiserView?.font = Fonts.NewsDetails.Ads.advertiser
    }
}

// MARK: - GADUnifiedNativeAdLoaderDelegate
extension NewsAdCell: GADUnifiedNativeAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        loader.isHidden = true
        
        let mediaView = nativeAdView.mediaView
        
        headlineView?.text = nativeAd.headline
        
        bodyView?.text = nativeAd.body
        bodyView?.isHidden = nativeAd.body == nil
        
        advertiserView?.text = nativeAd.advertiser
        advertiserView?.isHidden = nativeAd.advertiser == nil
        
        mediaView?.mediaContent = nativeAd.mediaContent
        
        nativeAdView.nativeAd = nativeAd
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) { }
}

