//
//  BaseCollectionViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/29/24.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){ }
    func configureLayout(){ }
    func configureUI(){ }
}
