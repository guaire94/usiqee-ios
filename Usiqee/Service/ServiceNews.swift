//
//  ServiceNews.swift
//  Usiqee
//
//  Created by Amine on 29/06/2021.
//

import Firebase
import FirebaseFirestore

protocol ServiceNewsDelegate {
    func dataAdded(news: News)
    func dataModified(news: News)
    func dataRemoved(news: News)
    func notifyEmptyList()
    func didFinishLoading()
}

protocol ServiceNewsCarouselDelegate {
    func notifyEmptyCarouselList()
    func didFinishLoadingCarousel()
    func carouselDataAdded(news: News)
    func carouselDataModified(news: News)
    func carouselDataRemoved(news: News)
}

class ServiceNews {

    // MARK: Constants
    private enum Constants {
        static let numberOfItems: Int = 10
    }
    // MARK: - Property
    private static var listener: ListenerRegistration?
    private static var lastSnapshot: QueryDocumentSnapshot?
    private static var carouselListener: ListenerRegistration?
    
    // MARK: - GET
    static func listenNews(delegate: ServiceNewsDelegate) {
        listener?.remove()

        var listener = FFirestoreReference.news
            .whereField("isDraft", isEqualTo: false)
            .whereField("inCarousel", isEqualTo: false)
            .order(by: "date", descending: true)
        
        if let lastSnapshot = lastSnapshot {
            listener = listener.start(afterDocument: lastSnapshot)
        }
        
        self.listener = listener
            .limit(to: Constants.numberOfItems)
            .addSnapshotListener { query, error in
                guard let snapshot = query else { return }
                var numberOfItems = snapshot.count
                if numberOfItems == .zero {
                    delegate.notifyEmptyList()
                }
                if let lastSnapshot = snapshot.documents.last {
                    self.lastSnapshot = lastSnapshot
                }
                snapshot.documentChanges.forEach { diff in
                    defer {
                        if numberOfItems == .zero {
                            delegate.didFinishLoading()
                        }
                    }
                    numberOfItems -= 1
                    guard let news = try? diff.document.data(as: News.self) else { return }

                    switch diff.type {
                    case .added:
                        delegate.dataAdded(news: news)
                    case .modified:
                        delegate.dataModified(news: news)
                    case .removed:
                        delegate.dataRemoved(news: news)
                    }
                }
            }
    }

    static func listenCarouselNews(delegate: ServiceNewsCarouselDelegate) {
        carouselListener?.remove()
        carouselListener = FFirestoreReference.news
            .whereField("inCarousel", isEqualTo: true)
            .addSnapshotListener { query, error in
            guard let snapshot = query else { return }
            var numberOfItems = snapshot.count
            if numberOfItems == .zero {
                delegate.notifyEmptyCarouselList()
            }
            snapshot.documentChanges.forEach { diff in
                defer {
                    if numberOfItems == .zero {
                        delegate.didFinishLoadingCarousel()
                    }
                }
                numberOfItems -= 1
                guard let news = try? diff.document.data(as: News.self) else { return }
                
                switch diff.type {
                case .added:
                    delegate.carouselDataAdded(news: news)
                case .modified:
                    delegate.carouselDataModified(news: news)
                case .removed:
                    delegate.carouselDataRemoved(news: news)
                }
            }
        }
    }
    
    static func syncAllInformation(news: NewsItem, completion: @escaping ([NewsSection], Author?) -> Void) {
        guard let newsId = news.news.id else { return }
        var newsSections: [NewsSection] = []
        var newsAuthor: Author?

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getNewsSections(newsId: newsId) { sections in
            newsSections = sections.sorted(by: { $0.rank < $1.rank })
            dispatchGroup.leave()
        }
        
        if let authorId = news.author?.authorId {
            dispatchGroup.enter()
            getAuthor(authorId: authorId) { author in
                newsAuthor = author
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(newsSections, newsAuthor)
        }
    }

    static func syncRelated(news: News, completion: @escaping (NewsItem) -> Void ) {
        guard let newsId = news.id else { return }
        var relatedAuthor: RelatedAuthor?

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        getNewsAuthor(newsId: newsId) { (author) in
            relatedAuthor = author
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            let item = NewsItem(news: news, author: relatedAuthor)
            completion(item)
        }
    }
    
    static func syncLikedNews(likedNews: RelatedNews, completion: @escaping (NewsItem) -> Void ) {
        let newsId = likedNews.newsId
        
        var news: News?
        var relatedAuthor: RelatedAuthor?

        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getNews(newsId: newsId) { (loadedNews) in
            news = loadedNews
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getNewsAuthor(newsId: newsId) { (author) in
            relatedAuthor = author
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            guard let news = news else { return }
            let item = NewsItem(news: news, author: relatedAuthor)
            completion(item)
        }
    }

    static func getNews(newsId: String, completion: @escaping (News?) -> Void) {
        FFirestoreReference.news.document(newsId).getDocument { (document, err) in
            guard let document = document, document.exists,
                  let news = try? document.data(as: News.self) else {
                completion(nil)
                return
            }
            completion(news)
        }
    }

    static func getNewsAuthor(newsId: String, completion: @escaping (RelatedAuthor?) -> Void) {
        FFirestoreReference.newsAuthor(newsId: newsId).getDocuments() { (querySnapshot, err) in
            var author: RelatedAuthor?
            defer {
                completion(author)
            }
            guard err == nil, let document = querySnapshot?.documents.first else {
                return
            }
            author = try? document.data(as: RelatedAuthor.self)
        }
    }
    
    static func getNewsSections(newsId: String, completion: @escaping ([NewsSection]) -> Void) {
        FFirestoreReference.newsSections(newsId: newsId).getDocuments() { (querySnapshot, err) in
            var sections: [NewsSection] = []
            defer {
                completion(sections)
            }
            
            guard err == nil, let documents = querySnapshot?.documents else {
                return
            }
            for document in documents {
                if let section = try? document.data(as: NewsSection.self) {
                    sections.append(section)
                }
            }
        }
    }
    
    static func getAuthor(authorId: String, completion: @escaping (Author?) -> Void) {
        FFirestoreReference.author.document(authorId).getDocument { (document, error) in
            guard let document = document, document.exists,
                  let author = try? document.data(as: Author.self) else {
                completion(nil)
                return
            }
            completion(author)
        }
    }
    
    // MARK: - POST
    static func likeNews(news: News)  {
        guard let userId = Auth.auth().currentUser?.uid,
              let newsId = news.id,
              let relatedNews = news.toRelated else {
            return
        }
        
        FFirestoreReference.userLikedNews(userId: userId).document(newsId).setData(relatedNews.toData)
    }
    
    static func unlikeNews(news: News)  {
        guard let userId = Auth.auth().currentUser?.uid,
              let newsId = news.id else {
            return
        }
        
        FFirestoreReference.userLikedNews(userId: userId).document(newsId).delete()
    }
}
