//
//  UIFont+Extension.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit

enum FontType {
    case primary
    case secondary
    case tertiary
    case quaternary
    
    var customFont: UIFont {
        switch self{
        case .primary:
            return UIFont.systemFont(ofSize: 19, weight: .medium)
        case .secondary:
            return UIFont.systemFont(ofSize: 17, weight: .medium)
        case .tertiary:
            return UIFont.systemFont(ofSize: 15, weight: .medium)
        case .quaternary:
            return UIFont.systemFont(ofSize: 13, weight: .medium)

        }
    }
}

extension UIFont {
    static var primary: UIFont {
        return FontType.primary.customFont
    }

    
    static var secondary: UIFont {
        return FontType.secondary.customFont
    }
    
    static var tertiary: UIFont {
        return FontType.tertiary.customFont
    }
    
    static var quaternary: UIFont {
        return FontType.quaternary.customFont
    }

}
