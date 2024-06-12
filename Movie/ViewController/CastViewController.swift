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
    
    let castTableView = UITableView(frame: .zero, style: .plain)
    
    var movieId: Int?
    
    var movieName: String?
    
    var posterImage: String?
    
    var backDropImage: String?
    
    var overView: String?
    
    var isOpened = false
    
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
                    self.list = value.cast
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func configureNav(){
        let back = UIBarButtonItem(image:Constant.Image.left, style: .plain, target: self, action: #selector(backButtonClicked))
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
        view.backgroundColor = .white

        titleLabel.textColor = .white
        titleLabel.font = Constant.Font.heavy
        titleLabel.text = movieName
        
        posterImageView.contentMode = .scaleAspectFill
        backdropImageView.contentMode = .scaleToFill
        
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
            cell.configureData(overView!)
            
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
        return section == 0 ? "OverView" : "Cast"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 0){
            isOpened.toggle()
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}
