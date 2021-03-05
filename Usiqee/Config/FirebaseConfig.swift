//
//  Reference.swift
//  Usiqee
//
//  Created by Quentin Gallois on 21/10/2020.
//

import Firebase

#if DEBUG
   let firebaseEnv = "Staging"
#else
   let firebaseEnv = "Release"
#endif

let db = Firestore.firestore()

enum FirebaseCollection {
    
    // MARK: - ENV
    static var env: String = "Env"
    
    // MARK: - GLOBAL
    static var follower: String = "Follower"
    static var like: String = "Like"
    static var comment: String = "Comment"

    // MARK: - VERSION
    static var version: String = "Version"
    
    // MARK: - NEWS
    static var news: String = "News"
    static var newsSection: String = "Section"

    // MARK: - AUTHOR
    static var author: String = "Author"

    // MARK: - EVENT
    static var event: String = "Event"

    // MARK: - ARTIST
    static var artist: String = "Artist"

    // MARK: - BAND
    static var band: String = "Band"

    // MARK: - RELEASE
    static var release: String = "Release"
    static var item: String = "Item"
    static var mainArtist: String = "MainArtist"
    static var mainBand: String = "MainBand"

    // MARK: - USER
    static var user: String = "User"
    
    // MARK: - LANGUAGE
    static var language: String = "Language"
    
    // MARK: - RELATED
    static var relatedArtist: String = "RelatedArtist"
    static var relatedBand: String = "RelatedBand"
    static var relatedNews: String = "RelatedNews"
    static var relatedAuthor: String = "RelatedAuthor"
    static var relatedEvent: String = "RelatedEvents"
    static var relatedLanguage: String = "RelatedLanguage"
    static var relatedRelease: String = "RelatedRelease"
}

enum FFirestoreReference {

    // MARK: - ENV
    static var env: DocumentReference {
        db.collection(FirebaseCollection.env).document(firebaseEnv)
    }
    
    // MARK: - VERSION
    static var version: DocumentReference {
        env.collection(FirebaseCollection.version).document("iOS")
    }
    
    // MARK: - NEWS
    static var news: CollectionReference {
        env.collection(FirebaseCollection.news)
    }
    static func newsSections(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.newsSection)
    }
    static func newsLikes(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.like)
    }
    static func newsComments(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.comment)
    }
    static func newsRelatedArtists(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.relatedArtist)
    }
    static func newsRelatedBands(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.relatedBand)
    }
    static func newsRelatedNews(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.relatedNews)
    }

    
    // MARK: - AUTHOR
    static var author: CollectionReference {
        env.collection(FirebaseCollection.author)
    }
    
    // MARK: - EVENT
    static var event: CollectionReference {
        env.collection(FirebaseCollection.event)
    }
    static func eventRelatedArtists(eventId: String) -> CollectionReference {
        event.document(eventId).collection(FirebaseCollection.relatedArtist)
    }
    static func eventRelatedBands(eventId: String) -> CollectionReference {
        event.document(eventId).collection(FirebaseCollection.relatedBand)
    }
    
    // MARK: - ARTIST
    static var artist: CollectionReference {
        env.collection(FirebaseCollection.artist)
    }
    static func artistFollower(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.follower)
    }
    static func artistRelatedEvent(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.relatedEvent)
    }
    static func artistRelatedNews(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.relatedNews)
    }
    static func artistRelatedRelease(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.relatedRelease)
    }
    static func artistRelatedLanguage(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.relatedLanguage)
    }
    static func artistRelatedBands(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.relatedBand)
    }
    
    // MARK: - BAND
    static var band: CollectionReference {
        env.collection(FirebaseCollection.band)
    }
    static func bandFollower(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.follower)
    }
    static func bandRelatedEvent(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.relatedEvent)
    }
    static func bandRelatedNews(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.relatedNews)
    }
    static func bandRelatedRelease(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.relatedRelease)
    }
    static func bandRelatedLanguage(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.relatedLanguage)
    }
    static func bandRelatedArtist(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.relatedArtist)
    }
    
    // MARK: - RELEASE
    static var release: CollectionReference {
        env.collection(FirebaseCollection.release)
    }
    static func releaseMainArtist(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.mainArtist)
    }
    static func releaseMainBand(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.mainBand)
    }
    static func releaseRelatedArtist(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.relatedArtist)
    }
    static func releaseRelatedBand(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.relatedBand)
    }
    static func releaseItem(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.item)
    }
    static func releaseItemMainArtist(releaseId: String, itemId: String) -> CollectionReference {
        releaseItem(releaseId: releaseId).document(itemId).collection(FirebaseCollection.mainArtist)
    }
    static func releaseItemMainBand(releaseId: String, itemId: String) -> CollectionReference {
        releaseItem(releaseId: releaseId).document(itemId).collection(FirebaseCollection.mainBand)
    }
    static func releaseItemRelatedArtist(releaseId: String, itemId: String) -> CollectionReference {
        releaseItem(releaseId: releaseId).document(itemId).collection(FirebaseCollection.relatedArtist)
    }
    static func releaseItemRelatedBand(releaseId: String, itemId: String) -> CollectionReference {
        releaseItem(releaseId: releaseId).document(itemId).collection(FirebaseCollection.relatedBand)
    }
    
    // MARK: - USER
    static var user: CollectionReference {
        env.collection(FirebaseCollection.user)
    }
    static func userFollowedArtist(userId: String) -> CollectionReference {
        event.document(userId).collection(FirebaseCollection.relatedArtist)
    }
    static func eventFollowedBands(userId: String) -> CollectionReference {
        event.document(userId).collection(FirebaseCollection.relatedBand)
    }
    static func eventLikedNews(userId: String) -> CollectionReference {
        event.document(userId).collection(FirebaseCollection.relatedNews)
    }
    
    // MARK: - LANGUAGE
    static var language: CollectionReference {
        env.collection(FirebaseCollection.language)
    }
}

enum FStorageReference {
    
    // MARK: - ENV
    static var env: StorageReference {
        Storage.storage().reference(withPath: FirebaseCollection.env).child(firebaseEnv)
    }

    // MARK: - NEWS
    static func newsLikes(newsId: String, userId: String) -> StorageReference {
        env.child(FirebaseCollection.news).child(newsId).child(FirebaseCollection.like).child(userId)
    }
    static func newsComments(newsId: String, userId: String) -> StorageReference {
        env.child(FirebaseCollection.news).child(newsId).child(FirebaseCollection.comment).child(userId)
    }

    // MARK: - AUTHOR
    static func author(authorId: String) -> StorageReference {
        env.child(FirebaseCollection.author).child(authorId)
    }
    
    // MARK: - ARTIST
    static func artist(artistId: String) -> StorageReference {
        env.child(FirebaseCollection.artist).child(artistId)
    }
    static func artistFollowers(artistId: String, userId: String) -> StorageReference {
        env.child(FirebaseCollection.artist).child(artistId).child(FirebaseCollection.follower).child(userId)
    }
    
    // MARK: - BAND
    static func band(bandId: String) -> StorageReference {
        env.child(FirebaseCollection.band).child(bandId)
    }
    static func bandFollowers(bandId: String, userId: String) -> StorageReference {
        env.child(FirebaseCollection.band).child(bandId).child(FirebaseCollection.follower).child(userId)
    }

    // MARK: - RELEASE
    static func release(releaseId: String) -> StorageReference {
        env.child(FirebaseCollection.release).child(releaseId)
    }
    static func releaseItem(releaseId: String, itemId: String) -> StorageReference {
        env.child(FirebaseCollection.release).child(releaseId).child(FirebaseCollection.item).child(itemId)
    }
    
    // MARK: - USER
    static func user(userId: String) -> StorageReference {
        env.child(FirebaseCollection.user).child(userId)
    }
    
    // MARK: - LANGUAGE
    static func language(languageId: String) -> StorageReference {
        env.child(FirebaseCollection.language).child(languageId)
    }

}
