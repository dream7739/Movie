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
        static let tertiary = UIFont.systemFont(ofSize: 14, weight: .medium)
        static let quarternary = UIFont.systemFont(ofSize: 13, weight: .medium)
    }
    
    enum Image {
        static let empty = UIImage()
        static let up = UIImage(systemName: "chevron.up")
        static let down = UIImage(systemName: "chevron.down")
        static let left = UIImage(systemName: "chevron.left")
        static let right = UIImage(systemName: "chevron.right")
        static let list = UIImage(systemName: "list.bullet")
        static let search = UIImage(systemName: "magnifyingglass")
        static let more = UIImage(systemName: "ellipsis.circle")
        static let trend = UIImage(systemName: "chart.line.uptrend.xyaxis")
        static let latest = UIImage(systemName: "movieclapper")!
        static let play = UIImage(named: "play")!
    }
    
    enum Color {
        static let empty = Constant.Color.black.withAlphaComponent(0.5)
        static let black = UIColor.black
        static let white = UIColor.white
        static let primary = UIColor(red: 76/255, green: 76/255, blue: 76/255, alpha: 1)
        static let secondary = UIColor(red: 130/255, green: 130/255, blue: 130/255, alpha: 1)
        static let tertiary = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)

    }
}
