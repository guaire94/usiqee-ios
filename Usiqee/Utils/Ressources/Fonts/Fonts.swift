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
    
    enum FollowedArtist {
        static var title: UIFont {
            Fonts.SofiaProRegular.withSize(with: 18)
        }
        static var numberOfFollowing: UIFont {
            Fonts.HelveticaRegular.withSize(with: 11)
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
            Fonts.SofiaProRegular.withSize(with: 21)
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
        enum Cell {
            static var header: UIFont {
                Fonts.SofiaProBold.withSize(with: 18)
            }
            static var name: UIFont {
                Fonts.SofiaProRegular.withSize(with: 16)
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
                Fonts.HelveticaMedium.withSize(with: 15)
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
}
