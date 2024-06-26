//
//  CastTableViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import Kingfisher
import SnapKit

class CastTableViewCell: BaseTableViewCell {
    
    let castImageView = UIImageView()
    
    let nameLabel = UILabel()
    
    let descriptionLabel = UILabel()
    
    override func configureHierarchy(){
        contentView.addSubview(castImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
    }
    
    override func configureLayout(){
        castImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(50)
            make.height.equalTo(70)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalTo(castImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(nameLabel)
        }
        
    }
    
    override func configureUI(){
        castImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = Constant.Font.secondary
        
        descriptionLabel.font = Constant.Font.tertiary
        descriptionLabel.textColor = .lightGray
    }
}

extension CastTableViewCell {
    func configureData(_ data: Cast){
        nameLabel.text = data.original_name
        
        if let url = data.profileURL {
            castImageView.kf.indicatorType = .activity
            castImageView.kf.setImage(with: url)
            castImageView.layer.cornerRadius = 5
            castImageView.clipsToBounds = true
        }else{
            castImageView.backgroundColor = Constant.Color.empty
        }
       
        descriptionLabel.text = data.description
    }
}
