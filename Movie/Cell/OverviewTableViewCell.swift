//
//  OverviewTableViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import SnapKit

class OverviewTableViewCell: BaseTableViewCell {
    
    let overviewLabel = UILabel()
    let openImageView = UIImageView()
    
    override func configureHierarchy(){
        contentView.addSubview(overviewLabel)
        contentView.addSubview(openImageView)
    }
    
    override func configureLayout(){
        overviewLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        openImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
            make.size.equalTo(20)
        }
        
    }
    
    override func configureUI(){
        overviewLabel.font = Constant.Font.tertiary
        overviewLabel.numberOfLines = 2
        
        openImageView.image = Constant.Image.down
        openImageView.tintColor = .black
    }
}

extension OverviewTableViewCell {
    func configureData(_ data: String){
        overviewLabel.text = data
    }
}
