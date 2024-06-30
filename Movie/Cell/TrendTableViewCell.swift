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
    
    let stackView = UIStackView()
    
    let dateView = UIView()
    let trendView = UIView()

    let dateLabel = UILabel()
    let moveImageView = UIImageView()
    let rateStackView = UIStackView()
    let rateLabel = UILabel()
    let rateValueLabel = UILabel()
    let titleLabel = UILabel()
    let logoImage = UIImageView()
    let descriptionLabel = UILabel()
    let categoryLabel = UILabel()
    
    override func configureHierarchy(){
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(dateView)
        stackView.addArrangedSubview(trendView)
        
        dateView.addSubview(dateLabel)
        
        trendView.addSubview(moveImageView)
        trendView.addSubview(rateStackView)
        rateStackView.addArrangedSubview(rateLabel)
        rateStackView.addArrangedSubview(rateValueLabel)
        trendView.addSubview(logoImage)
        trendView.addSubview(titleLabel)
        trendView.addSubview(descriptionLabel)
        trendView.addSubview(categoryLabel)
    }
    
    override func configureLayout(){
        stackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(15)
        }
        
        dateView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.15)
        }

        dateLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.leading.equalToSuperview()
        }
        
        moveImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        rateStackView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(moveImageView).inset(20)
            make.width.equalTo(70)
            make.height.equalTo(25)
        }
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(moveImageView.snp.bottom).offset(12)
            make.leading.equalTo(moveImageView)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
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
        stackView.axis = .horizontal
        
        dateView.isHidden = true
        
        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .center
        dateLabel.text = "7월\n19"
        
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
        
        logoImage.contentMode = .scaleAspectFit

        descriptionLabel.font = Constant.Font.tertiary
        descriptionLabel.textColor = Constant.Color.secondary
        descriptionLabel.numberOfLines = 3
        
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
        
        if let url = data.logoURL{
            logoImage.kf.setImage(with: url)
        }else{
            logoImage.backgroundColor = Constant.Color.empty
        }
        
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
            genre += "\(name)"
            if filteredGenre.last != name {
                genre += " ᐧ "
            }
        }
        return genre
    }
}

