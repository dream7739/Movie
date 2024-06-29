//
//  UIButton.Configuration+Extension.swift
//  Movie
//
//  Created by 홍정민 on 6/29/24.
//

import UIKit

extension UIButton.Configuration {
    static var category: UIButton.Configuration {
        var configuration =  UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .black
        return configuration
    }

}
