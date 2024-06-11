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
    
    let titleLabel = UILabel()
    
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
        contentView.addSubview(titleLabel)
    }
    
    func configureLayout(){
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    func configureUI(){
        posterImageView.contentMode = .scaleAspectFill
        
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = .tertiary
        titleLabel.numberOfLines = 0
    }
    
    func configureData(_ data: Search){
    
        if let poster = data.poster_path {
            let url = URL(string: APIURL.imgURL + poster)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: url)
        }else{
            posterImageView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            titleLabel.text = data.title ?? "No Title"
        }
        
    }
    
    override func prepareForReuse() {
        posterImageView.image = UIImage()
        posterImageView.backgroundColor = .white
        titleLabel.text = ""        
    }

}
