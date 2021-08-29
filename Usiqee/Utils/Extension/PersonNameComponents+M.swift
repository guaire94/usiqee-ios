//
//  PersonNameComponents+M.swift
//  Usiqee
//
//  Created by Guaire94 on 29/08/2021.
//

import Foundation

extension PersonNameComponents {
    
    var username: String {
        var username = givenName ?? ""
        if let familyName = self.familyName  {
            username += " " + familyName
        }
        return username
    }
}
