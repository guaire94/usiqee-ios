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
    case HelveticaLight = "Helvetica-Light"
    case HelveticaMedium = "Helvetica-Medium"
    case HelveticaItalic = "Helvetica-Italic"
    case SofiaProDisplayRegular = "SFProDisplay-Regular"
    
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
                Fonts.SofiaProRegular.withSize(with: 17)
            }
            static var fieldDescription: UIFont {
                Fonts.SofiaProRegular.withSize(with: 17)
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
        
        enum Events {
            static var date: UIFont {
                Fonts.HelveticaRegular.withSize(with: 18)
            }
            static var type: UIFont {
                Fonts.HelveticaRegular.withSize(with: 13)
            }
            static var description: UIFont {
                Fonts.HelveticaRegular.withSize(with: 13)
            }
        }
        enum Bio {
            static var title: UIFont {
                Fonts.SofiaProDisplayRegular.withSize(with: 16)
            }
            static var description: UIFont {
                Fonts.SofiaProDisplayRegular.withSize(with: 14)
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
    
    enum Events {
        static var title: UIFont {
            Fonts.SofiaProBold.withSize(with: 18)
        }
        static var filterBadge: UIFont {
            Fonts.HelveticaRegular.withSize(with: 6)
        }
        enum Cell {
            static var header: UIFont {
                Fonts.SofiaProBold.withSize(with: 18)
            }
            static var name: UIFont {
                Fonts.SofiaProBold.withSize(with: 16)
            }
            static var type: UIFont {
                Fonts.HelveticaLight.withSize(with: 11)
            }
            static var description: UIFont {
                Fonts.HelveticaRegular.withSize(with: 12)
            }
            static var time: UIFont {
                Fonts.HelveticaRegular.withSize(with: 12)
            }
            static var nextMonthButton: UIFont {
                Fonts.SofiaProBold.withSize(with: 14)
            }
            static var previousMonthButton: UIFont {
                Fonts.SofiaProBold.withSize(with: 14)
            }
            static var emptyMessage: UIFont {
                Fonts.SofiaProRegular.withSize(with: 18)
            }
        }
    }
    
    enum EventDetails {
        static var name: UIFont {
            Fonts.SofiaProBold.withSize(with: 24)
        }
        static var type: UIFont {
            Fonts.HelveticaRegular.withSize(with: 18)
        }
        static var description: UIFont {
            Fonts.SofiaProBold.withSize(with: 24)
        }
        static var date: UIFont {
            Fonts.HelveticaMedium.withSize(with: 22)
        }
        static var time: UIFont {
            Fonts.HelveticaMedium.withSize(with: 22)
        }
        static var button: UIFont {
            Fonts.HelveticaMedium.withSize(with: 18)
        }
    }
    
    enum EventsFilter {
        static var title: UIFont {
            Fonts.SofiaProBold.withSize(with: 21)
        }
        static var resetButton: UIFont {
            Fonts.HelveticaRegular.withSize(with: 15)
        }
        static var validateButton: UIFont {
            Fonts.HelveticaRegular.withSize(with: 18)
        }
        enum Cell {
            static var header: UIFont {
                Fonts.SofiaProBold.withSize(with: 18)
            }
            static var title: UIFont {
                Fonts.HelveticaRegular.withSize(with: 17)
            }
        }
    }
    
    enum EventsDateFilter {
        static var title: UIFont {
            Fonts.SofiaProBold.withSize(with: 21)
        }
        static var validateButton: UIFont {
            Fonts.HelveticaRegular.withSize(with: 18)
        }
    }
    
    enum MonthYearDatePicker {
        static var text: UIFont {
            Fonts.HelveticaRegular.withSize(with: 17)
        }
    }
    
    enum News {
        enum Cell {
            static var title: UIFont {
                Fonts.SofiaProBold.withSize(with: 14)
            }
            static var author: UIFont {
                Fonts.HelveticaRegular.withSize(with: 11)
            }
            static var date: UIFont {
                Fonts.HelveticaRegular.withSize(with: 10)
            }
        }
        enum Carousel {
            static var title: UIFont {
                Fonts.SofiaProBold.withSize(with: 20)
            }
            static var author: UIFont {
                Fonts.HelveticaRegular.withSize(with: 12)
            }
            static var date: UIFont {
                Fonts.HelveticaRegular.withSize(with: 11)
            }
            static var hour: UIFont {
                Fonts.HelveticaRegular.withSize(with: 11)
            }
        }
    }
    
    enum NewsDetails {
        enum Overview {
            static var title: UIFont {
                Fonts.SofiaProBold.withSize(with: 22)
            }
            static var author: UIFont {
                Fonts.HelveticaRegular.withSize(with: 14)
            }
            static var date: UIFont {
                Fonts.HelveticaRegular.withSize(with: 13)
            }
            static var hour: UIFont {
                Fonts.HelveticaRegular.withSize(with: 13)
            }
        }
        enum Text {
            static var content: UIFont {
                Fonts.HelveticaRegular.withSize(with: 16)
            }
        }
        enum Author {
            static var name: UIFont {
                Fonts.HelveticaRegular.withSize(with: 15)
            }
            static var description: UIFont {
                Fonts.HelveticaItalic.withSize(with: 13)
            }
            static var externalLink: UIFont {
                Fonts.HelveticaRegular.withSize(with: 13)
            }
        }
        enum Ads {
            static var headline: UIFont {
                Fonts.HelveticaRegular.withSize(with: 17)
            }
            static var advertiser: UIFont {
                Fonts.HelveticaItalic.withSize(with: 14)
            }
            static var body: UIFont {
                Fonts.HelveticaRegular.withSize(with: 14)
            }
        }
    }
}
