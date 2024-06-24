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
    
    var list: [Trend] = []
    var page = 1
    
    var trendResult = TrendResult(results: [], total_pages: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.shared.callGenreList{
            APIManager.shared.callTrend(page: self.page) { trendResult in
                self.trendResult = trendResult
                self.trendTableView.reloadData()
            }
        }
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
        
        navigationItem.title = "TREND"
    }
}

extension TrendViewController {
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
        trendTableView.prefetchDataSource = self
        trendTableView.rowHeight = 480
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
        vc.trend = data
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension TrendViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            page += 1
            if idx.row == trendResult.results.count - 4 && page <= trendResult.total_pages {
                APIManager.shared.callTrend(page: page) { trendResult in
                    self.trendResult.results.append(contentsOf: trendResult.results)
                    self.trendTableView.reloadData()
                }
            }
        }
    }
}
