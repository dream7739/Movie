//
//  RecommendViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/24/24.
//

import UIKit
import SnapKit

class RecommendViewController: UIViewController {
    
    let similarLabel = UILabel()
    
    let recommendLabel = UILabel()
    
    let posterLabel = UILabel()

    lazy var similarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    lazy var posterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())

    var movieId: Int?

    var similar = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
    var recommend = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
    var poster = PosterResult(posters: [])

    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing:CGFloat = 10
        let inset:CGFloat = 10
        let width =  (view.bounds.width - (spacing * 2) - (inset * 2)) / 3
        let height = view.bounds.height / 5
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return layout
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let movieId else { return }
        APIManager.shared.callSimilar(id: movieId, page: 1) { movieResult in
            self.similar = movieResult
            self.similarCollectionView.reloadData()
        }
        
        APIManager.shared.callRecommend(id: movieId, page: 1) { movieResult in
            self.recommend = movieResult
            self.recommendCollectionView.reloadData()
        }
        
        APIManager.shared.callPoster(id: movieId) { posterResult in
            self.poster = posterResult
            self.posterCollectionView.reloadData()
        }
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureCollectionView()
        
        navigationItem.title = "RECOMMEND"
     
    }
}

extension RecommendViewController {
    func configureHierarchy(){
        view.addSubview(similarLabel)
        view.addSubview(recommendLabel)
        view.addSubview(posterLabel)
        view.addSubview(similarCollectionView)
        view.addSubview(recommendCollectionView)
        view.addSubview(posterCollectionView)
    }
    
    func configureLayout(){
        similarLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(similarLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.bounds.height / 5 + 20)
        }
        
        recommendLabel.snp.makeConstraints { make in
            make.top.equalTo(similarCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.bounds.height / 5 + 20)
        }
        
        posterLabel.snp.makeConstraints { make in
            make.top.equalTo(recommendCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
        
        posterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(posterLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.bounds.height / 5 + 20)
        }
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        similarLabel.text = "비슷한 영화"
        similarLabel.font = Constant.Font.primary
        
        recommendLabel.text = "추천 영화"
        recommendLabel.font = Constant.Font.primary
        
        posterLabel.text = "포스터"
        posterLabel.font = Constant.Font.primary
    }
    
    func configureCollectionView(){
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.prefetchDataSource = self
        similarCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        similarCollectionView.showsHorizontalScrollIndicator = false
        
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        recommendCollectionView.prefetchDataSource = self
        recommendCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        recommendCollectionView.showsHorizontalScrollIndicator = false
        
        posterCollectionView.delegate = self
        posterCollectionView.dataSource = self
        posterCollectionView.prefetchDataSource = self
        posterCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        posterCollectionView.showsHorizontalScrollIndicator = false

    }
}


extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarCollectionView {
            return similar.results.count
        }else if collectionView == recommendCollectionView{
            return recommend.results.count
        }else{
            return poster.posters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
      
        if collectionView == similarCollectionView {
            let data = similar.results[indexPath.item]
            cell.configureData(data)
        }else if collectionView == recommendCollectionView {
            let data = recommend.results[indexPath.item]
            cell.configureData(data)
        }else{
            let data = poster.posters[indexPath.item]
            cell.configureData(data)
        }
        
        return cell
    }

}

extension RecommendViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        if collectionView == similarCollectionView {
            for idx in indexPaths {
                if idx.item == similar.results.count - 4 {
                    similar.page += 1
                    if similar.page <= similar.total_pages {
                        guard let movieId else { return }
                        APIManager.shared.callSimilar(id: movieId, page: similar.page) { movieResult in
                            self.similar.results.append(contentsOf: movieResult.results)
                            self.similarCollectionView.reloadData()
                        }
                    }
                }
            }
        }else if collectionView == recommendCollectionView {
            for idx in indexPaths {
                if idx.item == recommend.results.count - 4 {
                    recommend.page += 1
                    if recommend.page <= recommend.total_pages {
                        guard let movieId else { return }
                        APIManager.shared.callRecommend(id: movieId, page: recommend.page) { movieResult in
                            self.recommend.page += 1
                            self.recommendCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
}
