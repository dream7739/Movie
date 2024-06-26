//
//  TrendCell.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import Kingfisher
import SnapKit

class TrendTableViewCell : BaseTableViewCell {
    
    let categoryLabel = UILabel()
    let shadowView = UIView()
    let trendView = UIView()
    let moveImageView = UIImageView()
    let rateStackView = UIStackView()
    let rateLabel = UILabel()
    let rateValueLabel = UILabel()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    override func configureHierarchy(){
        contentView.addSubview(shadowView)
        shadowView.addSubview(trendView)
        
        trendView.addSubview(moveImageView)
        trendView.addSubview(rateStackView)
        rateStackView.addArrangedSubview(rateLabel)
        rateStackView.addArrangedSubview(rateValueLabel)
        trendView.addSubview(titleLabel)
        trendView.addSubview(descriptionLabel)
        trendView.addSubview(categoryLabel)
    }
    
    override func configureLayout(){
        shadowView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        
        trendView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        moveImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(300)
        }
        
        rateStackView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(moveImageView).inset(20)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(moveImageView.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(4)
            make.leading.equalTo(descriptionLabel)
        }
        
    }
    
    override func configureUI(){
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.3
        shadowView.layer.shadowOffset = CGSize(width: 3, height: 5)
        
        trendView.backgroundColor = .white
        trendView.layer.cornerRadius = 10
        trendView.clipsToBounds = true
        
        moveImageView.contentMode = .scaleAspectFill
        
        rateStackView.axis = .horizontal
        rateStackView.distribution = .fillEqually
        
        rateLabel.font = Constant.Font.tertiary
        rateLabel.textAlignment = .center
        rateLabel.textColor = .white
        rateLabel.backgroundColor = Constant.Color.theme
        
        rateValueLabel.font = Constant.Font.tertiary
        rateValueLabel.textAlignment = .center
        rateValueLabel.backgroundColor = .white
        
        titleLabel.font = Constant.Font.secondary
        
        descriptionLabel.font = Constant.Font.tertiary
        descriptionLabel.textColor = Constant.Color.secondary
        descriptionLabel.numberOfLines = 2
        
        categoryLabel.font = Constant.Font.tertiary
        categoryLabel.textColor = Constant.Color.secondary

    }
}

extension TrendTableViewCell {
    func configureData(_ data: Movie){
        
        if let url = data.backDropURL{
            moveImageView.kf.setImage(with: url)
        }else{
            moveImageView.backgroundColor = Constant.Color.empty
        }
        
        rateLabel.text = "평점"
        
        rateValueLabel.text = data.rateDescription
        
        titleLabel.text = data.title
        
        descriptionLabel.text = data.overview
        
        categoryLabel.text = getGenre(data.genre_ids)
        
    }
    
    private func getGenre(_ genreIds: [Int]) -> String {
        var genre = ""
        var filteredGenre: [String] = []
        
        for id in genreIds {
            filteredGenre += GenreResult.genreList.filter{ $0.id == id}.map{ $0.name }
        }
        
        for name in filteredGenre {
            genre += "# \(name) "
        }
        return genre
    }
}

