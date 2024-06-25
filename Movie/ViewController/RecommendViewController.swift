//
//  RecommendViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import UIKit
import SnapKit

class RecommendViewController: UIViewController {
    
    let recommendTableView = UITableView()
    
    var movieId: Int?
    
    var list: [[ Any ]] = [[], [], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movieId else { return }
        
        callAPI()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureTableView()
        
        navigationItem.title = "RECOMMEND"
    }
}

extension RecommendViewController {
    enum Section: CaseIterable{
        case similar
        case recommend
        case poster
        
        var titleText: String {
            switch self {
            case .similar:
                return "비슷한영화"
            case .recommend:
                return "추천영화"
            case .poster:
                return "포스터"
            }
        }
    }
    
    func callAPI(){
        guard let movieId else { return }

        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async {
            APIManager.shared.callSimilar(id: movieId, page: 1) { movieResult in
                self.list[0] = movieResult.results
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            APIManager.shared.callRecommend(id: movieId, page: 1) { movieResult in
                self.list[1] = movieResult.results
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            APIManager.shared.callPoster(id: movieId) { posterResult in
                self.list[2] = posterResult.posters
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.recommendTableView.reloadData()
        }
    }
    
    func configureHierarchy(){
        view.addSubview(recommendTableView)
    }
    
    func configureLayout(){
        recommendTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI(){
        view.backgroundColor = .white
    }
    
    func configureTableView(){
        recommendTableView.delegate = self
        recommendTableView.dataSource = self
        recommendTableView.register(RecommendTableViewCell.self, forCellReuseIdentifier: RecommendTableViewCell.identifier)
        recommendTableView.rowHeight = 240
        recommendTableView.separatorStyle = .none
    }
}

extension RecommendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecommendTableViewCell.identifier, for: indexPath) as! RecommendTableViewCell
        
        cell.titleLabel.text = RecommendViewController.Section.allCases[indexPath.row].titleText
        cell.selectionStyle = .none

        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        cell.collectionView.reloadData()
        return cell
    }
}


extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        
        if collectionView.tag == 0 || collectionView.tag == 1{
            if let data = list[collectionView.tag][indexPath.item] as? Movie {
                cell.configureData(data)
            }
        }else{
            if let data = list[collectionView.tag][indexPath.item] as? Poster {
                cell.configureData(data)
            }
        }
        
        return cell
    }
    
}
