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
    case SofiaProItalic = "SofiaPro-Italic"
    case HelveticaRegular = "Helvetica"
    case HelveticaBold = "Helvetica-Bold"
    
    private func withSize(with size: CGFloat) -> UIFont {
        guard let font = UIFont(name: rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    enum Global {
        static var emptyMessage: UIFont {
            Fonts.SofiaProRegular.withSize(with: 18)
        }
        enum Form {
            static var textField: UIFont {
                Fonts.SofiaProBold.withSize(with: 17)
            }
            static var fieldDescription: UIFont {
                Fonts.SofiaProBold.withSize(with: 17)
            }
        }
    }
    
    enum AllArtist {
        static var title: UIFont {
            Fonts.SofiaProBold.withSize(with: 18)
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
    
    enum FollowedArtist {
        static var title: UIFont {
            Fonts.SofiaProBold.withSize(with: 18)
        }
        static var numberOfFollowing: UIFont {
            Fonts.HelveticaRegular.withSize(with: 11)
        }
        enum Cell {
            static var title: UIFont {
                Fonts.HelveticaRegular.withSize(with: 11)
            }
        }
    }
    
    enum ArtistDetails {
        static var title: UIFont {
            Fonts.SofiaProBold.withSize(with: 27)
        }
        static var followButton: UIFont {
            Fonts.HelveticaRegular.withSize(with: 12)
        }
        static var followers: UIFont {
            Fonts.SofiaProRegular.withSize(with: 18)
        }
        
        enum Menu {
            static var item: UIFont {
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
    
    enum AccountNotLogged {
        static var title: UIFont {
            Fonts.SofiaProBold.withSize(with: 36)
        }
        static var subtitle: UIFont {
            Fonts.SofiaProItalic.withSize(with: 18)
        }
        static var `continue`: UIFont {
            Fonts.HelveticaRegular.withSize(with: 15)
        }
        static var icon: UIFont {
            Fonts.SofiaProRegular.withSize(with: 14)
        }
    }
    
    enum AccountDetails {
        static var userName: UIFont {
            Fonts.SofiaProBold.withSize(with: 21)
        }
        static var artistName: UIFont {
            Fonts.HelveticaRegular.withSize(with: 14)
        }
    }
    
    enum AccountSettings {
        static var title: UIFont {
            Fonts.SofiaProRegular.withSize(with: 20)
        }
        static var sectionTitle: UIFont {
            Fonts.HelveticaBold.withSize(with: 15)
        }
        static var sectionItem: UIFont {
            Fonts.HelveticaRegular.withSize(with: 14)
        }
        static var logout: UIFont {
            Fonts.HelveticaRegular.withSize(with: 15)
        }
    }
    
    enum PreAuth {
        static var signIn: UIFont {
            Fonts.HelveticaRegular.withSize(with: 13)
        }
        static var signUp: UIFont {
            Fonts.HelveticaRegular.withSize(with: 18)
        }
        static var separator: UIFont {
            Fonts.HelveticaRegular.withSize(with: 18)
        }
    }
    
    enum SignIn {
        static var valid: UIFont {
            Fonts.HelveticaRegular.withSize(with: 15)
        }
        static var forgetPassword: UIFont {
            Fonts.HelveticaRegular.withSize(with: 15)
        }
    }
    
    enum SignUp {
        static var valid: UIFont {
            Fonts.HelveticaRegular.withSize(with: 15)
        }
    }
    
    enum ForgetPassword {
        static var valid: UIFont {
            Fonts.HelveticaRegular.withSize(with: 15)
        }
    }
}

