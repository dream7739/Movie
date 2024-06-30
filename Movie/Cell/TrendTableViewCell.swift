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
    let backdropImage = UIImageView()
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
        
        trendView.addSubview(backdropImage)
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
            make.width.equalToSuperview().multipliedBy(0.1)
        }

        dateLabel.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.leading.equalToSuperview()
        }
        
        backdropImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        
        rateStackView.snp.makeConstraints { make in
            make.leading.bottom.equalTo(backdropImage).inset(20)
            make.width.equalTo(70)
            make.height.equalTo(22)
        }
        
        logoImage.snp.makeConstraints { make in
            make.top.equalTo(backdropImage.snp.bottom).offset(12)
            make.leading.equalTo(backdropImage).inset(15)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalTo(descriptionLabel)
        }
        
    }
    
    override func configureUI(){
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        dateView.isHidden = true
        
        dateLabel.numberOfLines = 0
        dateLabel.textAlignment = .center
        
        trendView.backgroundColor = .white
        trendView.layer.borderColor = UIColor.lightGray.cgColor
        trendView.layer.borderWidth = 0.5
        trendView.layer.cornerRadius = 10
        trendView.clipsToBounds = true
        
        backdropImage.contentMode = .scaleAspectFill
        
        rateStackView.axis = .horizontal
        rateStackView.distribution = .fillEqually
        
        rateLabel.font = Constant.Font.tertiary
        rateLabel.textAlignment = .center
        rateLabel.textColor = .white
        rateLabel.backgroundColor = Constant.Color.black
        
        rateValueLabel.font = Constant.Font.tertiary
        rateValueLabel.textAlignment = .center
        rateValueLabel.backgroundColor = .white
        
        titleLabel.font = .boldSystemFont(ofSize: 17)
        
        logoImage.contentMode = .scaleAspectFit

        descriptionLabel.font = Constant.Font.tertiary
        descriptionLabel.textColor = Constant.Color.primary
        descriptionLabel.numberOfLines = 3
        
        categoryLabel.font = Constant.Font.quarternary
        categoryLabel.textColor = Constant.Color.secondary

    }
    
    override func prepareForReuse() {
        backdropImage.image = nil
        logoImage.image = nil
    }
}

extension TrendTableViewCell {
    func configureData(_ data: Movie){

        if !dateView.isHidden {
            let date = data.dateDescription
            
            if let idx = date.firstIndex(of: "월") {
                let attributedString = NSMutableAttributedString(string: date)
                let secondIdx = date.index(after: idx)
                let range = NSRange(secondIdx..<date.endIndex, in: date)
                attributedString.addAttributes(
                    [.font : UIFont.systemFont(ofSize: 25, weight: .heavy)],
                    range: range
                )
                dateLabel.attributedText = attributedString
            }else{
                dateLabel.text = date
            }
        }
        
        if let url = data.backDropURL{
            backdropImage.kf.setImage(with: url)
        }else{
            backdropImage.backgroundColor = Constant.Color.empty
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
            filteredGenre += GenreResult.genreList.filter{
                $0.id == id
            }.map{
                $0.name
            }
        }
        
        for name in filteredGenre {
            genre += "\(name)"
            if filteredGenre.last != name {
                genre += " ᐧ "
            }
        }
        
        return genre
    }
    
    func cancelDownload(){
        logoImage.kf.cancelDownloadTask()
        backdropImage.kf.cancelDownloadTask()
    }
    
    
}

