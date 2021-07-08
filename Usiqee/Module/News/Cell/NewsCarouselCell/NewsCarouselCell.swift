//
//  NewsCarouselCell.swift
//  Usiqee
//
//  Created by Amine on 30/06/2021.
//

import UIKit

protocol NewsCarouselCellDelegate: AnyObject {
    func didSelectNews(at index: Int)
}

class NewsCarouselCell: UITableViewCell {

    //MARK: - Constant
    enum Constants {
        static let height: CGFloat = 371
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsCarouselCell"
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    // MARK: - Properties
    private var news: [NewsItem] = []
    private weak var delegate: NewsCarouselCellDelegate?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(news: [NewsItem], delegate: NewsCarouselCellDelegate?) {
        self.delegate = delegate
        self.news = news
        pageControl.numberOfPages = news.count
        collectionView.reloadData()
    }
    
    // MARK: - Private
    private func setupUI() {
        setupArtistsCollectionView()
    }
    
    private func setupArtistsCollectionView() {
        collectionView.register(NewsCarouselItemCell.Constants.nib, forCellWithReuseIdentifier: NewsCarouselItemCell.Constants.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource
extension NewsCarouselCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCarouselItemCell.Constants.identifier, for: indexPath) as? NewsCarouselItemCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(item: news[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewsCarouselCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.frame.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectNews(at: indexPath.row)
    }
}
