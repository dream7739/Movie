//
//  CategoryCollectionViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/29/24.
//

import UIKit
import SnapKit

class CategoryCollectionViewCell: BaseCollectionViewCell {
    let categoryButton = UIButton()
    
    override func configureHierarchy() {
        contentView.addSubview(categoryButton)
    }
    
    override func configureLayout() {
        categoryButton.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        var configuration =  UIButton.Configuration.filled()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .black
        configuration.title = "🔥공개 예정"
        categoryButton.configuration = configuration
    }
}
