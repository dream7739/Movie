//
//  BaseViewController.swift
//  Movie
//
//  Created by 홍정민 on 6/25/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 21)]
        let backButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backButtonItem.tintColor = Constant.Color.primary
        navigationItem.backBarButtonItem = backButtonItem
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    
    func configureHierarchy(){
        
    }
    
    func configureLayout(){
        
    }
    
    func configureUI(){
        
    }
}
