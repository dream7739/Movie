//
//  TrendViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import Alamofire
import SnapKit


class TrendViewController: UIViewController {

    let trendTableView = UITableView()
    
    var genreList: [Genre] = []
    
    var list: [Trend] = [] {
        didSet {
            trendTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callGenreList()
        
        configureNav()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
    }
    
    func  callGenreList(){
        let header: HTTPHeaders = [
            "Authorization" : APIKey.trendKey,
            "accept" : "application/json"
        ]
        
        let param: Parameters = ["language" : "ko-kr"]
        
        AF.request(APIURL.genreURL,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: header)
        .responseDecodable(of: GenreResult.self) { response in
            switch response.result {
            case .success(let value):
                self.genreList = value.genres
                self.callTrendMovie()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callTrendMovie(){
        let header: HTTPHeaders = [
            "Authorization" : APIKey.trendKey,
            "accept" : "application/json"
        ]
        
        let param: Parameters = ["language" : "ko-kr"]
        
        AF.request(APIURL.trendURL,
                   method: .get,
                   parameters: param,
                   encoding: URLEncoding.queryString,
                   headers: header)
        .responseDecodable(of: TrendResult.self) { response in
            switch response.result {
            case .success(let value):
                self.list = value.results
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureNav(){
        let list = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(listButtonClicked))
        
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonClicked))
        
        navigationItem.leftBarButtonItem = list
        navigationItem.rightBarButtonItem = search
        navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func listButtonClicked(){ }
    
    @objc func searchButtonClicked(){
        let vc = SearchViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func configureHierarchy(){
        view.addSubview(trendTableView)
    }
    
    func configureLayout(){
        trendTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI(){
        view.backgroundColor = .white
    }
    
    func configureTableView(){
        trendTableView.delegate = self
        trendTableView.dataSource = self
        trendTableView.rowHeight = 430
        trendTableView.separatorStyle = .none
        
        trendTableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
    }

}

extension TrendViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        
        let data = list[indexPath.row]
        cell.configureData(data)
        
        let genre = genreList.filter{ $0.id == data.genre_ids[0] }.map{ $0.name }.first
        cell.categoryLabel.text = "# \(genre ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        let movieId = data.id
        let movieName = data.title
        let posterImage = data.poster_path
        let backDropImage = data.backdrop_path

        let vc = CastViewController()
        vc.movieId = movieId
        vc.movieName = movieName
        vc.posterImage = posterImage
        vc.backDropImage = backDropImage
        vc.overView = data.overview
        
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
