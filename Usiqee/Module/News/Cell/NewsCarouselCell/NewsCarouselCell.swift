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
        static let height: CGFloat = UIScreen.main.bounds.width
        static let nib: UINib = UINib(nibName: Constants.identifier, bundle: nil)
        static let identifier: String = "NewsCarouselCell"
        fileprivate static let animationDuration: TimeInterval = 6.0
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var pageControl: UIPageControl!
    
    // MARK: - Properties
    private var news: [NewsItem] = []
    private weak var delegate: NewsCarouselCellDelegate?
    private var timer: Timer?
    
    // MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    func configure(news: [NewsItem], delegate: NewsCarouselCellDelegate?) {
        self.delegate = delegate
        self.news = news
        pageControl.numberOfPages = news.count
        reload()
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
    
    private func reload() {
        collectionView.reloadData()
        guard !news.isEmpty else { return }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: Constants.animationDuration, repeats: true) { [weak self] _ in
            guard let self = self,
                  !self.collectionView.isDragging else { return }
            let row = (self.pageControl.currentPage+1) % self.news.count
            self.pageControl.currentPage = row
            let index = IndexPath(row: row, section: 0)
            self.collectionView.scrollToItem(at: index, at: .right, animated: true)
        }
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
