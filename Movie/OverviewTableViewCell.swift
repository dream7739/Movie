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
        contentView.addSubview(overviewLabel)
    }
    
    func configureLayout(){
        overviewLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
    }
    
    func configureUI(){
        overviewLabel.font = .tertiary
        overviewLabel.numberOfLines = 0
    }
    
    func configureData(_ data: String){
        overviewLabel.text = data
    }
    
    @objc func expandButtonClicked(){
        overviewLabel.snp.updateConstraints { make in
            make.height.equalTo(100)
        }
    }
}
