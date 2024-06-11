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

class SearchViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    let backButton = UIButton(type: .system)
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let emptyView = UIView()
    
    let announceLabel = UILabel()
    
    let subAnnounceLabel = UILabel()
    
    var list = SearchResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
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
        configureHierarchy()
        configureLayout()
        configureUI()
        callSearch(query)
    }
    
    func configureHierarchy(){
        view.addSubview(searchBar)
        view.addSubview(backButton)
        view.addSubview(collectionView)
        
        view.addSubview(emptyView)
        emptyView.addSubview(announceLabel)
        emptyView.addSubview(subAnnounceLabel)
    }
    
    func configureLayout(){
        searchBar.snp.makeConstraints { make in
            make.top.trailing.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(backButton.snp.trailing)
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.size.equalTo(44)
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
    
    func configureUI(){
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        collectionView.keyboardDismissMode = .onDrag
        
        searchBar.delegate = self
        searchBar.placeholder = "영화를 검색하세요"
        searchBar.tintColor = .black
        searchBar.searchBarStyle = .minimal
        
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        backButton.tintColor = .black
        backButton.setImage(.back, for: .normal)
        
        emptyView.isHidden = true
        announceLabel.text = "이런! 찾으시는 작품이 없습니다."
        announceLabel.font = .systemFont(ofSize: 24, weight: .heavy)
        announceLabel.textAlignment = .center
        
        subAnnounceLabel.text = "다른 영화를 검색해보세요"
        subAnnounceLabel.font = .secondary
        subAnnounceLabel.textColor = .gray
        subAnnounceLabel.textAlignment = .center

    }
    
    @objc func backButtonClicked(){
        dismiss(animated: true)
    }
    
    func callSearch(_ query: String){
        print(#function)
        
        var component = URLComponents(string: APIURL.searchURL)
        let query = URLQueryItem(name: "query", value: "\(query)")
        let lang = URLQueryItem(name: "language", value: "ko-kr")
        let page = URLQueryItem(name: "page", value: "\(page)")
        
        component?.queryItems = [query, lang, page]
        
        guard let url = component?.url else { return }
        
        let header: HTTPHeaders = [
            "Authorization" : APIKey.trendKey,
            "accept": "application/json"]
        
        AF.request(url,
                   method: .get,
                   headers: header
                   )
        .responseDecodable(of: SearchResult.self) { response in
            switch response.result {
            case .success(let value):
                
                if self.page == 1 {
                    self.list = value
                }else{
                    self.list.results.append(contentsOf: value.results)
                }
                
                self.collectionView.reloadData()
                
                //검색 결과가 없는 경우에는 result = []
                //검색 결과가 없는 경우에는 scrollToItem되지 않도록 함
                if self.page == 1 && self.list.results.count != 0{
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
                
                //결과가 없는 경우에 emptyView 보이도록 지정
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
    
  
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for idx in indexPaths {
            if list.results.count - 2 == idx.row && page <= list.total_pages{
                page += 1
                callSearch(query)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        for idx in indexPaths {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: idx) as! SearchCollectionViewCell
            cell.cancelDownload()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        
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
            callSearch(query)
        }
    }

}
