//
//  ManagerNews.swift
//  Usiqee
//
//  Created by Amine on 29/06/2021.
//

import Foundation

protocol ManagerNewsDelegate: AnyObject {
    func didUpdateNews()
    func didStartLoading()
    func didFinishLoading()
    func didLoadMore()
}

class ManagerNews {
    
    // MARK: - Singleton
    static let shared = ManagerNews()
    private init() {}
    
    // MARK: - Properties
    weak var delegate: ManagerNewsDelegate?
    private var isLoadingNews: Bool = false
    private var isLoadingCarousel: Bool = false
    
    var allNews: [NewsItem] = [] {
        didSet {
            delegate?.didUpdateNews()
            finishLoadingIfNeeded()
        }
    }
    
    var carouselNews: [NewsItem] = [] {
        didSet {
            delegate?.didUpdateNews()
            finishLoadingIfNeeded()
        }
    }
    
    //MARK: - Public
    func setupListener() {
        reloadData()
    }
    
    func loadMore() {
        guard !isLoadingNews else {
            delegate?.didFinishLoading()
            return
        }
        delegate?.didLoadMore()
        isLoadingNews = true
        ServiceNews.listenNews(delegate: self)
    }
    
    // MARK: - Private
    private func reloadData() {
        isLoadingNews = true
        isLoadingCarousel = true
        delegate?.didStartLoading()
        allNews.removeAll()
        carouselNews.removeAll()
        ServiceNews.listenNews(delegate: self)
        ServiceNews.listenCarouselNews(delegate: self)
    }
    
    private func finishLoadingIfNeeded() {
        if !isLoadingNews, !isLoadingCarousel {
            DispatchQueue.main.async {
                self.delegate?.didFinishLoading()
            }
        }
    }
}

// MARK: - ServiceNewsDelegate
extension ManagerNews: ServiceNewsDelegate {
    func dataAdded(news: News) {
        ServiceNews.syncRelated(news: news) { [weak self] item in
            guard let self = self else { return }
            self.allNews.append(item)
            self.allNews.sort(by: { $0.news.date.dateValue() > $1.news.date.dateValue() })
        }
    }
    
    func dataModified(news: News) {
        guard let index = allNews.firstIndex(where: { $0.news.id == news.id }) else { return }
        ServiceNews.syncRelated(news: news) { [weak self] item in
            guard let self = self else { return }
            self.allNews[index] = item
            self.allNews.sort(by: { $0.news.date.dateValue() > $1.news.date.dateValue() })
        }
    }
    
    func dataRemoved(news: News) {
        guard let index = allNews.firstIndex(where: { $0.news.id == news.id }) else { return }
        allNews.remove(at: index)
    }
    
    func notifyEmptyList() {
        isLoadingNews = false
        finishLoadingIfNeeded()
    }
    
    func didFinishLoading() {
        isLoadingNews = false
    }
}

// MARK: - ServiceNewsCarouselDelegate
extension ManagerNews: ServiceNewsCarouselDelegate {
    func notifyEmptyCarouselList() {
        isLoadingCarousel = false
        finishLoadingIfNeeded()
    }
    
    func didFinishLoadingCarousel() {
        isLoadingCarousel = false
    }
    
    func carouselDataAdded(news: News) {
        ServiceNews.syncRelated(news: news) { [weak self] item in
            guard let self = self else { return }
            self.carouselNews.append(item)
            self.carouselNews.sort(by: { $0.news.date.dateValue() > $1.news.date.dateValue() })
        }
    }
    
    func carouselDataModified(news: News) {
        guard let index = carouselNews.firstIndex(where: { $0.news.id == news.id }) else { return }
        ServiceNews.syncRelated(news: news) { [weak self] item in
            guard let self = self else { return }
            self.carouselNews[index] = item
            self.carouselNews.sort(by: { $0.news.date.dateValue() > $1.news.date.dateValue() })
        }
    }
    
    func carouselDataRemoved(news: News) {
        guard let index = carouselNews.firstIndex(where: { $0.news.id == news.id }) else { return }
        carouselNews.remove(at: index)
    }
}
