//
//  SearchCollectionViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/11/24.
//

import UIKit
import Kingfisher
import SnapKit

class PosterCollectionViewCell: UICollectionViewCell {
    
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
    
    override func prepareForReuse() {
        posterImageView.image = Constant.Image.empty
        posterImageView.backgroundColor = .white
        titleLabel.text = ""
    }
    
    private func configureHierarchy(){
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
    }
    
    private func configureLayout(){
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    private func configureUI(){
        posterImageView.contentMode = .scaleAspectFill
        
        posterImageView.layer.cornerRadius = 8
        posterImageView.clipsToBounds = true
        
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = Constant.Font.tertiary
        titleLabel.numberOfLines = 0
    }
    
    func configureData(_ data: Movie){
        if let url = data.posterURL {
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(with: url)
        }else{
            posterImageView.backgroundColor = Constant.Color.empty
            titleLabel.text = data.title ?? "No Title"
        }
    }
    
    func cancelDownload(){
        posterImageView.kf.cancelDownloadTask()
    }
    
}
