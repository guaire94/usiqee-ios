//
//  ArtistVCDataSource.swift
//  Usiqee
//
//  Created by Amine on 18/04/2021.
//

import Foundation

protocol ArtistVCDataSource: AnyObject {
    func filterBy() -> String?
}
