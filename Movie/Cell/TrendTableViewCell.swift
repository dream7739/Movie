//
//  TrendCell.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import Kingfisher
import SnapKit

class TrendTableViewCell : UITableViewCell {
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy(){
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
    
    private func configureLayout(){
        dateLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(20)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(2)
            make.leading.equalTo(dateLabel)
        }
        
        shadowView.snp.makeConstraints { make in
             make.top.equalTo(categoryLabel.snp.bottom).offset(8)
             make.horizontalEdges.equalToSuperview().inset(20)
             make.height.equalTo(340)
        }
        
        trendView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(moveImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
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
    
    private func configureUI(){
        dateLabel.textColor = .lightGray
        dateLabel.font = Constant.Font.tertiary
        
        categoryLabel.font = Constant.Font.primary
        
        shadowView.backgroundColor = .clear
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOpacity = 0.6
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
        rateLabel.backgroundColor = .systemIndigo
        
        rateValueLabel.font = Constant.Font.tertiary
        rateValueLabel.textAlignment = .center
        rateValueLabel.backgroundColor = .white
        
        titleLabel.font = Constant.Font.primary
        
        descriptionLabel.font = Constant.Font.secondary
        descriptionLabel.textColor = .gray
        
        seperatorLabel.backgroundColor = .gray
        
        detailLabel.text = "자세히보기"
        detailLabel.font = Constant.Font.secondary
        detailButton.setImage(Constant.Image.right, for: .normal)
        detailButton.tintColor = .gray
        
    }
    
    func configureData(_ data: Trend){
        dateLabel.text = data.release_date
        
        let url = APIURL.imgURL + "/\(data.backdrop_path)"
        moveImageView.kf.setImage(with: URL(string: url))
        
        rateLabel.text = "평점"
        
        rateValueLabel.text = String(format: "%.1f", data.vote_average)
        
        titleLabel.text = data.title
        
        descriptionLabel.text = data.overview
        
        
    }

}
