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

class CastViewController: UIViewController {
    
    let headerView = UIView()
    
    let backdropImageView = UIImageView()
    
    let titleLabel = UILabel()
    
    let posterImageView = UIImageView()
    
    let castTableView = UITableView()
    
    var movieId: Int?
    
    var movieName: String?
    
    var posterImage: String?
    
    var backDropImage: String?
    
    var list: [Cast] = []{
        didSet {
            castTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callCast()
        
        configureNav()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
    }
    
    func callCast(){
        
        let header: HTTPHeaders = [
            "Authorization" : APIKey.trendKey,
            "accept" : "application/json"
        ]
        
        let param: Parameters = ["language" : "ko-kr"]

        
        let url = APIURL.castURL + "/\(movieId!)/credits"
        
        AF.request(url,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: header)
        .responseDecodable(of: CastResult.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    self.list = value.cast
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func configureNav(){
        let back = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        navigationItem.leftBarButtonItem = back
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "출연/제작"
    }
    
    @objc func backButtonClicked(){
        navigationController?.popViewController(animated: true)
    }
    
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
            make.height.equalTo(240)
        }
        
        backdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(30)
        }
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(100)
            make.height.equalTo(130)
        }
        
        castTableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        titleLabel.textColor = .white
        titleLabel.font = .systemFont(ofSize: 25, weight: .heavy)
        titleLabel.text = movieName
        
        posterImageView.contentMode = .scaleAspectFill
        backdropImageView.contentMode = .scaleAspectFill
        
        let url = APIURL.imgURL
        
        if let posterImage {
            posterImageView.kf.setImage(with: URL(string: url+"/\(posterImage)"))
        }
        
        if let backDropImage {
            backdropImageView.kf.setImage(with: URL(string: url+"/\(backDropImage)"))
        }
        
    }
    
    func configureTableView(){
        castTableView.delegate = self
        castTableView.dataSource = self
        castTableView.rowHeight = 90
        castTableView.register(CastTableViewCell.self, forCellReuseIdentifier: CastTableViewCell.identifier)
    }
}

extension CastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = list[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: CastTableViewCell.identifier, for: indexPath) as! CastTableViewCell
        cell.configureData(data)
        return cell
    }
}
