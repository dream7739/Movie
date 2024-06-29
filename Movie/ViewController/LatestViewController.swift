//
//  LatestViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/29/24.
//

import UIKit
import SnapKit

//현재 상영중인 영화, 현재 인기있는 영화, 곧 개봉할 영화 3가지로 정보를 나누어 보여줄 것
class LatestViewController: BaseViewController {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    let tableView = UITableView()
    
    var result: MovieResult = MovieResult(page: 1, results: [], total_pages: 0, total_results: 0)
    
    func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: (view.bounds.width - 40) / 3, height: 40)
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "NEW & HOT"
        configureCollectionView()
    }
    
    override func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(tableView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        tableView.backgroundColor = .black
    }
}

extension LatestViewController{
    func configureCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
    }
}

extension LatestViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
}
