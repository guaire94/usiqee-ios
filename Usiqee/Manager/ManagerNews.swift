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
    private var isLoading: Bool = false
    
    var allNews: [NewsItem] = [] {
        didSet {
            delegate?.didUpdateNews()
            if !isLoading {
                delegate?.didFinishLoading()
            }
        }
    }
    
    //MARK: - Public
    func setupListener() {
        reloadData()
    }
    
    func loadMore() {
        guard !isLoading else {
            delegate?.didFinishLoading()
            return
        }
        delegate?.didLoadMore()
        isLoading = true
        ServiceNews.listenNews(delegate: self)
    }
    
    // MARK: - Private
    private func reloadData() {
        isLoading = true
        delegate?.didStartLoading()
        allNews.removeAll()
        ServiceNews.listenNews(delegate: self)
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
        isLoading = false
        delegate?.didFinishLoading()
    }
    
    func didFinishLoading() {
        isLoading = false
    }
}
