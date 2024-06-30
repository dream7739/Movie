//
//  Display.swift
//  Movie
//
//  Created by 홍정민 on 6/29/24.
//

import Foundation

enum Display {
    static let rowHeight:CGFloat = 420
    
    enum LatestCategory: String, CaseIterable {
        case upcoming = "🍿 개봉 예정"
        case popular = "🔥 모두의 인기 컨텐츠"
        case nowplaying = "👀 현재 상영중인 영화"
    }
}
