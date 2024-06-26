//
//  RecommendViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import UIKit
import SnapKit
import Alamofire

class RecommendViewController: BaseViewController {
    
    let recommendTableView = UITableView()
    
    var movieId: Int?
    
    var list: [[ Any ]] = [[], [], []]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
        configureTableView()
        
        navigationItem.title = "RECOMMEND"
    }
    
    override func configureHierarchy(){
        view.addSubview(recommendTableView)
    }
    
    override func configureLayout(){
        recommendTableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
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
            APIManager.shared.callRequest(request: .similar(id: movieId)) { (result: Result<MovieResult, AFError>) in
                switch result {
                case .success(let value):
                    self.list[0] = value.results
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async {
            APIManager.shared.callRequest(request: .recommend(id: movieId)) { (result: Result<MovieResult, AFError>) in
                switch result {
                case .success(let value):
                    self.list[1] = value.results
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        
        group.enter()
        print(APIRequest.poster(id: movieId).endPoint)
        DispatchQueue.global().async {
            APIManager.shared.callRequest(request: .poster(id: movieId)) { (result: Result<PosterResult, AFError>) in
                switch result {
                case .success(let value):
                    self.list[2] = value.posters
                case .failure(let error):
                    print("errorororo")
                    print(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.recommendTableView.reloadData()
        }
    }
    
    
    func configureTableView(){
        recommendTableView.delegate = self
        recommendTableView.dataSource = self
        recommendTableView.register(RecommendTableViewCell.self, forCellReuseIdentifier: RecommendTableViewCell.identifier)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 || indexPath.row == 1 {
            return 240
        }else {
            return 380
        }
    }
}


extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 || collectionView.tag == 1 {
            return CGSize(width: 120, height: 180)
        }else{
            return CGSize(width: 200, height: 320)
        }
    }
    
}
