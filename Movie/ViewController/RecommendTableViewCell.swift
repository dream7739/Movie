//
//  RecommendTableViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/25/24.
//

import UIKit
import SnapKit

class RecommendTableViewCell: UITableViewCell {
    
    let titleLabel = UILabel()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
   
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 180)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendTableViewCell {
    func configureHierarchy(){
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }
    
    func configureLayout(){
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
    
    func configureUI(){
        collectionView.showsHorizontalScrollIndicator = false
        titleLabel.font = Constant.Font.heavy
    }
}
