//
//  CastTableViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import Kingfisher
import SnapKit

class CastTableViewCell: UITableViewCell {
    
    let castImageView = UIImageView()
    
    let nameLabel = UILabel()
    
    let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy(){
        contentView.addSubview(castImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
    }
    
    func configureLayout(){
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
    
    func configureUI(){
        castImageView.contentMode = .scaleAspectFill
        castImageView.backgroundColor = .red
        castImageView.layer.cornerRadius = 6
        
        nameLabel.font = .secondary
        
        descriptionLabel.font = .tertiary
        descriptionLabel.textColor = .lightGray
    }
    
    func configureData(_ data: Cast){
        nameLabel.text = data.original_name

        if let profileImg = data.profile_path {
            let url = APIURL.imgURL + "\(profileImg)"
            castImageView.kf.setImage(with: URL(string: url))
            castImageView.layer.cornerRadius = 5
        }
                
        if let charactor = data.character, let cast_id = data.cast_id {
            descriptionLabel.text = charactor + " / " + "No.\(cast_id)"
        }
    }
}
