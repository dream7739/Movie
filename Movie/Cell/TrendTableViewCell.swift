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
    
    let dateLabel = UILabel()
    let categoryLabel = UILabel()
    let shadowView = UIView()
    let trendView = UIView()
    let moveImageView = UIImageView()
    let rateStackView = UIStackView()
    let rateLabel = UILabel()
    let rateValueLabel = UILabel()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let seperatorLabel = UILabel()
    let detailLabel = UILabel()
    let detailButton = UIButton()
    
    override func configureHierarchy(){
        contentView.addSubview(dateLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(shadowView)
        shadowView.addSubview(trendView)
        
        trendView.addSubview(moveImageView)
        trendView.addSubview(rateStackView)
        rateStackView.addArrangedSubview(rateLabel)
        rateStackView.addArrangedSubview(rateValueLabel)
        trendView.addSubview(titleLabel)
        trendView.addSubview(descriptionLabel)
        trendView.addSubview(seperatorLabel)
        trendView.addSubview(detailLabel)
        trendView.addSubview(detailButton)
    }
    
    override func configureLayout(){
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(4)
            make.leading.equalTo(dateLabel)
        }
        
        shadowView.snp.makeConstraints { make in
             make.top.equalTo(categoryLabel.snp.bottom).offset(12)
             make.horizontalEdges.equalToSuperview().inset(20)
             make.height.equalTo(400)
        }
        
        trendView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        moveImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(250)
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
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        seperatorLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(descriptionLabel)
            make.height.equalTo(1)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(seperatorLabel.snp.bottom).offset(16)
            make.leading.equalTo(seperatorLabel)
        }
        
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(seperatorLabel.snp.bottom).offset(16)
            make.trailing.equalTo(seperatorLabel)
            make.width.height.equalTo(30)
        }
        
    }
    
    override func configureUI(){
        dateLabel.textColor = .lightGray
        dateLabel.font = Constant.Font.tertiary
        
        categoryLabel.font = Constant.Font.secondary
        
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
        
        titleLabel.font = Constant.Font.primary
        
        descriptionLabel.font = Constant.Font.secondary
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 2
        
        seperatorLabel.backgroundColor = .gray
        
        detailLabel.text = "자세히보기"
        detailLabel.font = Constant.Font.secondary
        detailButton.setImage(Constant.Image.right, for: .normal)
        detailButton.tintColor = .gray
        
    }
}

extension TrendTableViewCell {
    func configureData(_ data: Movie){
        dateLabel.text = data.dateDescription
        
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

