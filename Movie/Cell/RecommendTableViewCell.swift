//
//  RecommendTableViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/25/24.
//

import UIKit
import SnapKit

class RecommendTableViewCell: BaseTableViewCell {
    
    let titleLabel = UILabel()
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.poster(direction: .horizontal)
    )
    
    override func configureHierarchy(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }
    
    override func configureLayout(){
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    override func configureUI(){
        collectionView.showsHorizontalScrollIndicator = false
        titleLabel.font = Constant.Font.primary
    }
}
