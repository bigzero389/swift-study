//
//  DetailViewController.swift
//  MyMovieChart
//
//  Created by bigzero on 2021/07/03.
//
import UIKit
import WebKit

class DetailViewController: UIViewController {
    @IBOutlet var wv: WKWebView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    var mvo: MovieVO!
    
    override func viewDidLoad() {
        self.wv.navigationDelegate = self
        
        NSLog("linkurl = \(self.mvo.detail!), title=\(self.mvo.title!)")
        
        // 화면의 title 셋팅
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        // test
//        self.mvo.detail = nil
        
        // URLRequest 인스턴스를 생성
        if let url = self.mvo.detail {
            // test
//            url = ""
            if let urlObj = URL(string: url) {
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
            }else {
                let alert = UIAlertController(title: "오류", message: "잘못된 url 입니다. URL: \(url)", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: {(_) in _ = self.navigationController?.popViewController(animated: true)})
                alert.addAction(cancelAction)
                self.present(alert, animated: false, completion: nil)
            }
        } else {
            self.alert("URL은 필수입니다.") {
                _ = self.navigationController?.popViewController(animated: true)
            }
//            let alert = UIAlertController(title: "오류", message: "URL은 필수입니다.", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: {(_) in _ = self.navigationController?.popViewController(animated: true)})
//            alert.addAction(cancelAction)
//            self.present(alert, animated: false, completion: nil)
        }
    }
    
}
// MARK:- WKNavigationDelegate 프로토콜 구현
extension DetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        self.alert("상세페이지를 읽어오지 못했습니다.") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        self.alert("상세페이지를 읽어오지 못했습니다.") {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}
extension UIViewController {
    func alert(_ message: String, onClick: (() -> Void)? = nil) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel) { (_) in
            onClick?()
        })
        DispatchQueue.main.async {
            self.present(controller, animated: false)
        }
    }
}
