//
//  SearchViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/11/24.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit

class SearchViewController: BaseViewController {
    
    let searchBar = UISearchBar()
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let emptyView = UIView()
    
    let announceLabel = UILabel()
    
    let subAnnounceLabel = UILabel()
    
    var list = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
    var page = 1
    
    var query = "애니"
    
    func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width - 40) / 3
        let height = (UIScreen.main.bounds.height - 100) / 4
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
        navigationItem.title = "SEARCH"
    }
    
    func callAPI(){
        APIManager.shared.callRequest(request: .search(query: query, page: page)) { (result: Result<MovieResult, AFError>) in
            switch result {
            case .success(let value):
                if self.page == 1 {
                    self.list = value
                }else{
                    self.list.results.append(contentsOf: value.results)
                }
                
                self.collectionView.reloadData()
                
                if self.page == 1 && self.list.results.count != 0{
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
                if self.list.results.count == 0 {
                    self.emptyView.isHidden = false
                }else{
                    self.emptyView.isHidden = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    override func configureHierarchy(){
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        
        view.addSubview(emptyView)
        emptyView.addSubview(announceLabel)
        emptyView.addSubview(subAnnounceLabel)
    }
    
    override func configureLayout(){
        searchBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        emptyView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        announceLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.4)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        subAnnounceLabel.snp.makeConstraints { make in
            make.top.equalTo(announceLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(announceLabel)
        }
    }
    
    override func configureUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.keyboardDismissMode = .onDrag
        
        searchBar.delegate = self
        searchBar.placeholder = "영화를 검색하세요"
        searchBar.tintColor = .black
        searchBar.searchBarStyle = .minimal
        
        emptyView.isHidden = true
        announceLabel.text = "이런! 찾으시는 작품이 없습니다."
        announceLabel.font = Constant.Font.heavy
        announceLabel.textAlignment = .center
        
        subAnnounceLabel.text = "다른 영화를 검색해보세요"
        subAnnounceLabel.font = Constant.Font.secondary
        subAnnounceLabel.textColor = .gray
        subAnnounceLabel.textAlignment = .center
    }
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for idx in indexPaths {
            if list.results.count - 2 == idx.item {
                page += 1
                if page <= list.total_pages{
                    callAPI()
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        for idx in indexPaths {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: idx) as! PosterCollectionViewCell
            cell.cancelDownload()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        let data = list.results[indexPath.row]
        
        cell.configureData(data)
        return cell
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //아무 텍스트 없이 검색 버튼 클릭 > 호출 안됨
        //공백만 있게 검색 버튼 클릭 > 호출 / 공백 포함되면 검색결과 달라지는 경우 있음
        //동일한 검색어 > 서버통신 이루어지도록 막기
        
        searchBar.resignFirstResponder()
        
        let input = searchBar.text!.trimmingCharacters(in: .whitespaces)
        
        if !input.isEmpty && !(input.caseInsensitiveCompare(query) == .orderedSame) {
            query = input
            page = 1
            callAPI()
        }
    }
    
}
