//
//  Constant.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit

enum Constant {
    
    enum Font {
        static let heavy = UIFont.systemFont(ofSize: 22, weight: .heavy)
        static let primary = UIFont.systemFont(ofSize: 19, weight: .medium)
        static let secondary = UIFont.systemFont(ofSize: 17, weight: .medium)
        static let tertiary = UIFont.systemFont(ofSize: 15, weight: .medium)
        static let quarternary = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    enum Image {
        static let empty = UIImage()

        static let up = UIImage(systemName: "chevron.up")!
        static let down = UIImage(systemName: "chevron.down")!
        static let left = UIImage(systemName: "chevron.left")!
        static let right = UIImage(systemName: "chevron.right")!
        
        static let list = UIImage(systemName: "list.bullet")!
        static let search = UIImage(systemName: "magnifyingglass")!
    }
    
    enum Color {
        static let empty = UIColor.black.withAlphaComponent(0.5)
    }
}
