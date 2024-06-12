//
//  OverviewTableViewCell.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import SnapKit

class OverviewTableViewCell: UITableViewCell {
    
    let overviewLabel = UILabel()
    
    let openImageView = UIImageView()
    
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
        contentView.addSubview(overviewLabel)
        contentView.addSubview(openImageView)
    }
    
    private func configureLayout(){
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
    
    private func configureUI(){
        overviewLabel.font = Constant.Font.tertiary
        overviewLabel.numberOfLines = 2
        
        openImageView.image = Constant.Image.down
        openImageView.tintColor = .black
    }
    
    func configureData(_ data: String){
        overviewLabel.text = data
    }
    
}
