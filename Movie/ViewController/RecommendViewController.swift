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

    lazy var similarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    var movieId: Int?

    var similar = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
    var recommend = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)

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
        view.addSubview(similarCollectionView)
        view.addSubview(recommendCollectionView)
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
    }
    
    func configureUI(){
        view.backgroundColor = .white
        
        similarLabel.text = "비슷한 영화"
        similarLabel.font = Constant.Font.primary
        
        recommendLabel.text = "추천 영화"
        recommendLabel.font = Constant.Font.primary
    }
    
    func configureCollectionView(){
        similarCollectionView.delegate = self
        similarCollectionView.dataSource = self
        similarCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        similarCollectionView.showsHorizontalScrollIndicator = false
        
        recommendCollectionView.delegate = self
        recommendCollectionView.dataSource = self
        recommendCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        recommendCollectionView.showsHorizontalScrollIndicator = false

    }
}


extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == similarCollectionView {
            return similar.results.count
        }else{
            return recommend.results.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
      
        if collectionView == similarCollectionView {
            let data = similar.results[indexPath.item]
            cell.configureData(data)
        }else{
            let data = recommend.results[indexPath.item]
            cell.configureData(data)
        }
        
        return cell
    }
    
    
}
