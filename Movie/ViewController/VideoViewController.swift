//
//  VideoViewController.swift
//  Movie
//
//  Created by 홍정민 on 7/1/24.
//

import UIKit
import WebKit
import Alamofire
import SnapKit

class VideoViewController: BaseViewController {
    let webView = WKWebView()
    
    let youtubeURL = "https://www.youtube.com/watch"
    
    var id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callVideo()
    }
    
    override func configureHierarchy() {
        view.addSubview(webView)
    }
    
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
    }
    
}


extension VideoViewController {
    func callVideo(){
        guard let id else { return }
        APIManager.shared.callRequest(request: .videos(id: id)) {
            (result: Result<VideoResult, AFError> ) in
            switch result {
            case .success(let value):
                self.loadWebView(value.results)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadWebView(_ videos: [Video]){
        guard let video = videos.first else{
            print("비디오 없음")
            return
        }
        
        guard let url = URL(string: youtubeURL + "?v=\(video.key)")else{
            print("url nil")
            return
        }
        
        webView.load(URLRequest(url: url))
    }
}

extension VideoViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
        print(#function)
        
    }
}
