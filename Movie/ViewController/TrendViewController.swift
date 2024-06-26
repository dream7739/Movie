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
    
    var page = 1
    
    var trendResult = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
        configureTableView()
        navigationItem.title = "TREND"
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
    func callAPI(){
        
        let group = DispatchGroup()
        
        group.enter()
        APIManager.shared.callRequest(request: .genre) { (result: Result<GenreResult, AFError>) in
            switch result {
            case .success(let value):
                GenreResult.genreList = value.genres
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.enter()
        APIManager.shared.callRequest(request: .trend(page: page)){ (result: Result<MovieResult, AFError>) in
            switch result {
            case .success(let value):
                self.trendResult = value
            case .failure(let error):
                print(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main){
            self.trendTableView.reloadData()
        }
    }
    
    func configureTableView(){
        trendTableView.delegate = self
        trendTableView.dataSource = self
        trendTableView.prefetchDataSource = self
        trendTableView.rowHeight = 460
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
                    APIManager.shared.callRequest(request: .trend(page: page)){ (result: Result<MovieResult, AFError>) in
                        switch result {
                        case .success(let value):
                            self.trendResult.results.append(contentsOf: value.results)
                            self.trendTableView.reloadData()
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            }
        }
    }
}
