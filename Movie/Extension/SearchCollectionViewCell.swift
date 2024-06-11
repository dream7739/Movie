//
//  SearchCollectionViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/11/24.
//

import UIKit
import Kingfisher
import SnapKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    let posterImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        contentView.addSubview(posterImageView)
    }
    
    func configureLayout(){
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(){
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.backgroundColor = .blue
    }
    

}
