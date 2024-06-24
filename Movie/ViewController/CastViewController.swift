//
//  CastViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

enum Section: Int, CaseIterable {
    case OverView = 0
    case Cast = 1
    
    var title: String {
       return "\(self)"
    }
}

class CastViewController: UIViewController {
    
    let headerView = UIView()
    
    let backdropImageView = UIImageView()
    
    let titleLabel = UILabel()
    
    let posterImageView = UIImageView()
    
    let castTableView = UITableView(frame: .zero, style: .plain)
    
    var trend: Trend?
    
    var list: [Cast] = []
    
    var isOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let trend{
            APIManager.shared.callCast(id: trend.id){ castResult in
                self.list = castResult.cast
                self.castTableView.reloadData()
            }

        }
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
        
        navigationItem.title = trend?.title

    }
    
  
}

extension CastViewController {
    func configureHierarchy(){
        view.addSubview(headerView)
        headerView.addSubview(backdropImageView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(posterImageView)
        
        view.addSubview(castTableView)
    }
    
    func configureLayout(){
        headerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(20)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(80)
            make.height.equalTo(100)
        }
        
        castTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI(){
        guard let trend else { return }
        
        view.backgroundColor = .white

        titleLabel.textColor = .white
        titleLabel.font = Constant.Font.heavy
        titleLabel.text = trend.title
        
        posterImageView.contentMode = .scaleAspectFill
        
        backdropImageView.contentMode = .scaleToFill
        backdropImageView.clipsToBounds = true
        
        if let url = trend.posterURL {
            posterImageView.kf.setImage(with: url)
        }else{
            posterImageView.backgroundColor = Constant.Color.empty
        }
        
        if let url = trend.backDropURL {
            backdropImageView.kf.setImage(with: url)
        }else{
            backdropImageView.backgroundColor = Constant.Color.empty
        }
        
    }
    
    func configureTableView(){
        castTableView.delegate = self
        castTableView.dataSource = self
        castTableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: OverviewTableViewCell.identifier)
        castTableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.identifier)
    }
}

extension CastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        }else{
            return 90
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as! OverviewTableViewCell
            
            if let overview = trend?.overview {
                cell.configureData(overview)
            }
            
            if isOpened{
                cell.overviewLabel.numberOfLines = 0
                cell.openImageView.image = Constant.Image.up
            }else{
                cell.overviewLabel.numberOfLines = 2
                cell.openImageView.image = Constant.Image.down
            }
            
            return cell
        }else{
            let data = list[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier, for: indexPath) as! CastTableViewCell
            cell.configureData(data)
            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section.allCases[section].title
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0){
            isOpened.toggle()
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}
