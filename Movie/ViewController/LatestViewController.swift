//
//  LatestViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/29/24.
//

import UIKit
import Alamofire
import SkeletonView
import SnapKit

class LatestViewController: BaseViewController {
    
    lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: CustomLayout.category()
    )
    
    let latestTableView = UITableView()
    
    let group = DispatchGroup()
    
    var page = 1
    
    var selectedIndex: Int = 0
    
    var movieResult = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTableView()
        navigationItem.title = "NEW & HOT"
        
        callUpcoming()
        
        latestTableView.isSkeletonable = true
        latestTableView.showSkeleton()
        
        group.notify(queue: .main){
            self.latestTableView.hideSkeleton()
            self.latestTableView.reloadData()
        }
        
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(latestTableView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        latestTableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
}

extension LatestViewController {
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            CategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier
        )
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    func configureTableView(){
        latestTableView.delegate = self
        latestTableView.dataSource = self
        latestTableView.prefetchDataSource = self
        latestTableView.register(TrendTableViewCell.self, forCellReuseIdentifier: TrendTableViewCell.identifier)
        latestTableView.rowHeight = Display.rowHeight
        latestTableView.separatorStyle = .none
    }
}

extension LatestViewController{
    //개봉 예정
    func callUpcoming(){
        group.enter()
        DispatchQueue.global().async(group: group){
            APIManager.shared.callRequest(request: .upcoming(page: self.page)) {
                (result: Result<MovieResult, AFError>) in
                switch result {
                case .success(let value):
                    if self.page == 1 {
                        self.movieResult = value
                    }else{
                        self.movieResult.results.append(contentsOf: value.results)
                    }
                    self.callImage(movie: value.results)
                case .failure(let error):
                    print(error)
                }
                self.group.leave()
            }
        }
    }
    
    //인기
    func callPopular(){
        group.enter()
        DispatchQueue.global().async(group: group){
            APIManager.shared.callRequest(request: .popular(page: self.page)) {
                (result: Result<MovieResult, AFError>) in
                switch result {
                case .success(let value):
                    if self.page == 1 {
                        self.movieResult = value
                    }else{
                        self.movieResult.results.append(contentsOf: value.results)
                    }
                    self.callImage(movie: value.results)
                case .failure(let error):
                    print(error)
                }
                self.group.leave()
            }
        }
    }
    
    //현재 상영중
    func callNowPlaying(){
        group.enter()
        DispatchQueue.global().async(group: group){
            APIManager.shared.callRequest(request: .nowPlaying(page: self.page)) {
                (result: Result<MovieResult, AFError>) in
                switch result {
                case .success(let value):
                    if self.page == 1 {
                        self.movieResult = value
                    }else{
                        self.movieResult.results.append(contentsOf: value.results)
                    }
                    self.callImage(movie: value.results)
                case .failure(let error):
                    print(error)
                }
                self.group.leave()
            }
        }
    }
    
    func callImage(movie: [Movie]){
        let start = (page - 1) * 20
        let end = movieResult.results.count
        
        for idx in start..<end {
            group.enter()
            APIManager.shared.callRequest(request: .poster(id: self.movieResult.results[idx].id)) {
                (result: Result<ImageResult, AFError>) in
                switch result {
                case .success(let value):
                    self.movieResult.results[idx].logo_path = value.logos.first?.file_path
                case .failure(let error):
                    print(error)
                }
                self.group.leave()
            }
        }
    }
}

extension LatestViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let button = UIButton()
        button.configuration = .category
        button.configuration?.title = Display.LatestCategory.allCases[indexPath.item].rawValue
        let size = button.intrinsicContentSize
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Display.LatestCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.categoryButton.configuration?.title = Display.LatestCategory.allCases[indexPath.item].rawValue
        cell.categoryButton.tag = indexPath.item
        cell.categoryButton.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
        return cell
    }
    
    @objc func categoryButtonClicked(_ sender : UIButton){
        if selectedIndex == sender.tag { return }
        switch sender.tag {
        case 0:
            selectedIndex = sender.tag
            page = 1
            callUpcoming()
            group.notify(queue: .main){
                self.latestTableView.reloadData()
                self.latestTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        case 1:
            selectedIndex = sender.tag
            page = 1
            callPopular()
            group.notify(queue: .main){
                self.latestTableView.reloadData()
                self.latestTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        case 2:
            selectedIndex = sender.tag
            page = 1
            callNowPlaying()
            group.notify(queue: .main){
                self.latestTableView.reloadData()
                self.latestTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        default:
            print("invalid indexPath item")
        }
    }
    
}

extension LatestViewController: UITableViewDelegate, SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return TrendTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        return skeletonView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath)
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  UITableView.automaticNumberOfSkeletonRows

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieResult.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: indexPath) as? TrendTableViewCell else { return UITableViewCell() }
        let data = movieResult.results[indexPath.row]
        
        if selectedIndex == 0 {
            cell.dateView.isHidden = false
        }else{
            cell.dateView.isHidden = true
        }
        
        cell.selectionStyle = .none
        cell.configureData(data)
        return cell
    }
}

extension LatestViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            if idx.row == movieResult.results.count - 4  {
                page += 1
                if page <= movieResult.total_pages {
                    callUpcoming()
                    
                    group.notify(queue: .main){
                        self.latestTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for idx in indexPaths {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TrendTableViewCell.identifier, for: idx) as? TrendTableViewCell else { return }
            cell.cancelDownload()
        }
    }
}
