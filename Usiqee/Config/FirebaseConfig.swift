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

var db: Firestore = {
    let settings = FirestoreSettings()
    settings.isPersistenceEnabled = true
    let db = Firestore.firestore()
    db.settings = settings
    return db
}()

enum FirebaseCollection {
    
    // MARK: - ENV
    static var env: String = "Env"
    
    // MARK: - VERSION
    static var version: String = "Version"
    
    // MARK: - NEWS
    static var news: String = "News"
    static var newsSections: String = "Sections"
    static var newsAuthor: String = "Authors"
    static var newsLikes: String = "Likes"
    static var newsComments: String = "Comments"
    static var newsArtists: String = "Artists"
    static var newsBands: String = "Bands"
    static var newsRelatedNews: String = "RelatedNews"

    // MARK: - AUTHOR
    static var author: String = "Author"

    // MARK: - EVENT
    static var event: String = "Event"
    static var eventArtists: String = "Artists"
    static var eventBands: String = "Bands"
    static var eventMainArtist: String = "MainArtist"
    static var eventMainBand: String = "MainBand"

    // MARK: - ARTIST
    static var artist: String = "Artist"
    static var artistBands: String = "Bands"
    static var artistFollowers: String = "Followers"
    static var artistReleases: String = "Releases"
    static var artistEvents: String = "Events"
    static var artistNews: String = "News"
    static var artistLanguages: String = "Languages"
    static var artistLabels: String = "Labels"

    // MARK: - BAND
    static var band: String = "Band"
    static var bandArtists: String = "Artists"
    static var bandFollowers: String = "Followers"
    static var bandReleases: String = "Releases"
    static var bandEvents: String = "Events"
    static var bandNews: String = "News"
    static var bandLanguages: String = "Languages"
    static var bandLabels: String = "Labels"

    // MARK: - RELEASE
    static var release: String = "Release"
    static var releaseMainArtist: String = "MainArtist"
    static var releaseMainBand: String = "MainBand"
    static var releaseArtists: String = "Artists"
    static var releaseBands: String = "Bands"

    // MARK: - ITEM
    static var releaseItems: String = "Items"
    static var releaseItemMainArtist: String = "MainArtist"
    static var releaseItemMainBand: String = "MainBand"
    static var releaseItemArtists: String = "Artists"
    static var releaseItemBands: String = "Bands"

    // MARK: - USER
    static var user: String = "User"
    static var userFollowedArtists: String = "FollowedArtists"
    static var userFollowedBands: String = "FollowedBands"
    static var userLikedNews: String = "LikedNews"

    // MARK: - LANGUAGE
    static var language: String = "Language"

    // MARK: - LABEL
    static var label: String = "Label"
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
        news.document(newsId).collection(FirebaseCollection.newsSections)
    }
    static func newsAuthor(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.newsAuthor)
    }
    static func newsLikes(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.newsLikes)
    }
    static func newsComments(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.newsComments)
    }
    static func newsArtists(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.newsArtists)
    }
    static func newsBands(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.newsBands)
    }
    static func newsRelatedNews(newsId: String) -> CollectionReference {
        news.document(newsId).collection(FirebaseCollection.newsRelatedNews)
    }

    // MARK: - AUTHOR
    static var author: CollectionReference {
        env.collection(FirebaseCollection.author)
    }
    
    // MARK: - EVENT
    static var event: CollectionReference {
        env.collection(FirebaseCollection.event)
    }
    static func eventArtists(eventId: String) -> CollectionReference {
        event.document(eventId).collection(FirebaseCollection.eventArtists)
    }
    static func eventBands(eventId: String) -> CollectionReference {
        event.document(eventId).collection(FirebaseCollection.eventBands)
    }
    static func eventMainArtist(eventId: String) -> CollectionReference {
        event.document(eventId).collection(FirebaseCollection.eventMainArtist)
    }
    static func eventMainBand(eventId: String) -> CollectionReference {
            event.document(eventId).collection(FirebaseCollection.eventMainBand)
        }
    
    // MARK: - ARTIST
    static var artist: CollectionReference {
        env.collection(FirebaseCollection.artist)
    }
    static func artistBands(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.artistBands)
    }
    static func artistFollowers(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.artistFollowers)
    }
    static func artistReleases(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.artistReleases)
    }
    static func artistEvents(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.artistEvents)
    }
    static func artistNews(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.artistNews)
    }
    static func artistLanguages(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.artistLanguages)
    }
    static func artistLabels(artistId: String) -> CollectionReference {
        artist.document(artistId).collection(FirebaseCollection.artistLabels)
    }
    
    // MARK: - BAND
    static var band: CollectionReference {
        env.collection(FirebaseCollection.band)
    }
    static func bandArtists(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.bandArtists)
    }
    static func bandFollowers(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.bandFollowers)
    }
    static func bandReleases(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.bandReleases)
    }
    static func bandEvents(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.bandEvents)
    }
    static func bandNews(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.bandNews)
    }
    static func bandLanguages(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.bandLanguages)
    }
    static func bandLabels(bandId: String) -> CollectionReference {
        band.document(bandId).collection(FirebaseCollection.bandLabels)
    }

    // MARK: - RELEASE
    static var release: CollectionReference {
        env.collection(FirebaseCollection.release)
    }
    static func releaseMainArtist(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.releaseMainArtist)
    }
    static func releaseMainBand(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.releaseMainBand)
    }
    static func releaseArtists(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.releaseArtists)
    }
    static func releaseBands(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.releaseBands)
    }
    static func releaseItems(releaseId: String) -> CollectionReference {
        release.document(releaseId).collection(FirebaseCollection.releaseItems)
    }
    static func releaseItemMainArtist(releaseId: String, itemId: String) -> CollectionReference {
        releaseItems(releaseId: releaseId).document(itemId).collection(FirebaseCollection.releaseItemMainArtist)
    }
    static func releaseItemMainBand(releaseId: String, itemId: String) -> CollectionReference {
        releaseItems(releaseId: releaseId).document(itemId).collection(FirebaseCollection.releaseItemMainBand)
    }
    static func releaseItemArtists(releaseId: String, itemId: String) -> CollectionReference {
        releaseItems(releaseId: releaseId).document(itemId).collection(FirebaseCollection.releaseItemArtists)
    }
    static func releaseItemBands(releaseId: String, itemId: String) -> CollectionReference {
        releaseItems(releaseId: releaseId).document(itemId).collection(FirebaseCollection.releaseItemBands)
    }
    
    // MARK: - USER
    static var user: CollectionReference {
        env.collection(FirebaseCollection.user)
    }
    static func userFollowedArtists(userId: String) -> CollectionReference {
        user.document(userId).collection(FirebaseCollection.userFollowedArtists)
    }
    static func userFollowedBands(userId: String) -> CollectionReference {
        user.document(userId).collection(FirebaseCollection.userFollowedBands)
    }
    static func userLikedNews(userId: String) -> CollectionReference {
        user.document(userId).collection(FirebaseCollection.userLikedNews)
    }
        
    // MARK: - LANGUAGE
    static var language: CollectionReference {
        env.collection(FirebaseCollection.language)
    }
    
    // MARK: - LABEL
    static var label: CollectionReference {
        env.collection(FirebaseCollection.label)
    }
}

enum FStorageReference {
    
    // MARK: - ENV
    static var env: StorageReference {
        Storage.storage().reference(withPath: FirebaseCollection.env).child(firebaseEnv)
    }

    // MARK: - NEWS
    static func newsLikes(newsId: String, userId: String) -> StorageReference {
        env.child(FirebaseCollection.news).child(newsId).child(FirebaseCollection.newsLikes).child(userId)
    }
    static func newsComments(newsId: String, userId: String) -> StorageReference {
        env.child(FirebaseCollection.news).child(newsId).child(FirebaseCollection.newsComments).child(userId)
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
        env.child(FirebaseCollection.artist).child(artistId).child(FirebaseCollection.artistFollowers).child(userId)
    }
    
    // MARK: - BAND
    static func band(bandId: String) -> StorageReference {
        env.child(FirebaseCollection.band).child(bandId)
    }
    static func bandFollowers(bandId: String, userId: String) -> StorageReference {
        env.child(FirebaseCollection.band).child(bandId).child(FirebaseCollection.bandFollowers).child(userId)
    }

    // MARK: - RELEASE
    static func release(releaseId: String) -> StorageReference {
        env.child(FirebaseCollection.release).child(releaseId)
    }
    static func releaseItem(releaseId: String, itemId: String) -> StorageReference {
        env.child(FirebaseCollection.release).child(releaseId).child(FirebaseCollection.releaseItems).child(itemId)
    }
    
    // MARK: - USER
    static func user(userId: String) -> StorageReference {
        env.child(FirebaseCollection.user).child(userId)
    }
    
    // MARK: - LANGUAGE
    static func language(languageId: String) -> StorageReference {
        env.child(FirebaseCollection.language).child(languageId)
    }
    
    // MARK: - Label
    static func label(labelId: String) -> StorageReference {
        env.child(FirebaseCollection.label).child(labelId)
    }
}
