//
//  TrendViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/10/24.
//

import UIKit
import Alamofire
import SnapKit


class TrendViewController: BaseViewController {
    
    let trendTableView = UITableView()
    
    let group = DispatchGroup()

    var page = 1
    
    var trendResult = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
    var imageResult:[Image] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationItem.title = "TREND"

        callGenreAPI()
        callTrendAPI()
        
        group.notify(queue: .main) {
            self.trendTableView.reloadData()
        }
    }
    
    override func configureHierarchy(){
        view.addSubview(trendTableView)
    }
    
    override func configureLayout(){
        trendTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

extension TrendViewController {
    func callGenreAPI(){
        group.enter()
        DispatchQueue.global().async(group: group) {
            APIManager.shared.callRequest(request: .genre) {
                (result: Result<GenreResult, AFError>) in
                self.group.leave()
                switch result {
                case .success(let value):
                    GenreResult.genreList = value.genres
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func callTrendAPI(){
        group.enter()
        DispatchQueue.global().async(group: group) {
            APIManager.shared.callRequest(request: .trend(page: self.page)){ (
                result: Result<MovieResult, AFError>) in
                self.group.leave()
                switch result {
                case .success(let value):
                    if self.page == 1 {
                        self.trendResult = value
                    }else{
                        self.trendResult.results.append(contentsOf: value.results)
                    }
                    
                    self.callImageAPI(movie: value.results)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func callImageAPI(movie: [Movie]){
        let start = (page - 1) * 20
        let end = trendResult.results.count
        
        for idx in start..<end {
            group.enter()
            APIManager.shared.callRequest(request: .poster(id: self.trendResult.results[idx].id)) {
                (result: Result<ImageResult, AFError>) in
                self.group.leave()
                switch result {
                case .success(let value):
                    self.trendResult.results[idx].logo_path = value.logos.first?.file_path
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func configureTableView(){
        trendTableView.delegate = self
        trendTableView.dataSource = self
        trendTableView.prefetchDataSource = self
        trendTableView.rowHeight = Display.rowHeight
        trendTableView.separatorStyle = .none
        trendTableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
    }
    
}

extension TrendViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendResult.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as! TrendTableViewCell
        
        let data = trendResult.results[indexPath.row]
        cell.configureData(data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = trendResult.results[indexPath.row]
        let vc = CastViewController()
        vc.movie = data
        navigationController?.pushViewController(vc, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension TrendViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            if idx.row == trendResult.results.count - 4  {
                page += 1
                if page <= trendResult.total_pages {
                    callTrendAPI()
                    
                    group.notify(queue: .main){
                        self.trendTableView.reloadData()
                    }
                }
            }
        }
    }
}
