//
//  Fonts.swift
//  Usiqee
//
//  Created by Amine on 21/04/2021.
//

import UIKit

enum Fonts: String {
    
    case SofiaProRegular = "SofiaPro"
    case SofiaProBold = "SofiaPro-Bold"
    case HelveticaRegular = "Helvetica"
    
    private func withSize(with size: CGFloat) -> UIFont {
        guard let font = UIFont(name: rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    enum AllArtist {
        static var title: UIFont {
            Fonts.SofiaProRegular.withSize(with: 18)
        }
        static var search: UIFont {
            Fonts.HelveticaRegular.withSize(with: 20)
        }
        enum Cell {
            static var title: UIFont {
                Fonts.HelveticaRegular.withSize(with: 14)
            }
        }
    }
    
    enum ArtistDetails {
        static var title: UIFont {
            Fonts.SofiaProBold.withSize(with: 27)
        }
        static var activity: UIFont {
            Fonts.SofiaProRegular.withSize(with: 14)
        }
        static var followers: UIFont {
            Fonts.SofiaProRegular.withSize(with: 18)
        }
        
        enum Menu {
            static var news: UIFont {
                Fonts.SofiaProRegular.withSize(with: 14)
            }
            static var calendar: UIFont {
                Fonts.SofiaProRegular.withSize(with: 14)
            }
            static var discography: UIFont {
                Fonts.SofiaProRegular.withSize(with: 14)
            }
        }
        
        enum Discography {
            static var title: UIFont {
                Fonts.SofiaProBold.withSize(with: 40)
            }
            static var subtitle: UIFont {
                Fonts.SofiaProRegular.withSize(with: 30)
            }
        }
    }
}

