//
//  ViewController.swift
//  Chapter08-APITest
//
//  Created by bigzero on 2021/08/22.
//
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    // Do any additional setup after loading the view.
    }

    @IBOutlet var currentTime: UILabel!
    @IBAction func callCurrentTime(_ sender: Any) {
        do {
            // 1. URL 설정 및 GET 방식으로 API 호출
            let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/currentTime")
            let response = try String(contentsOf: url!)
            currentTime.text = response
            currentTime.sizeToFit()

        } catch let e as NSError {
            print(e.localizedDescription)
        }
    }
    
    @IBOutlet var userId: UITextField!
    @IBOutlet var userName: UITextField!
    @IBOutlet var responseView: UITextView!
    
    @IBAction func post(_ sender: Any) {
        let userId = (userId.text)!
        let name = (userName.text)!
        let param = "userId=\(userId)&name=\(name)"
        let paramData = param.data(using: .utf8)
        
        let url = URL(string: "http://swiftapi.rubypaper.co.kr:2029/practice/echo")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error {
                NSLog("An error has occurred: \(e.localizedDescription)")
                return
            }

            print("Response Data =\(String(data: data!, encoding: .utf8)!)")

            // 5-2 응답처리 로직이ㅣ 여기 들어감
            // main 스레드에서 비동기로 처리
            DispatchQueue.main.async() {
                do {
                    let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                    guard let jsonObject = object else {
                        return
                    }
                    // JSON 값 추출
                    let result = jsonObject["result"] as? String
                    let timestamp = jsonObject["timestamp"] as? String
                    let userId = jsonObject["userId"] as? String
                    let name = jsonObject["name"] as? String

                    if result == "SUCCESS" {
                        self.responseView.text = "아이디 : \(userId!)" + "\n"
                                + "이름 : \(name!)" + "\n"
                                + "응답결과 : \(result!)" + "\n"
                                + "응답시간 : \(timestamp!)" + "\n"
                                + "요청방식 : x-www-form-urlendcoded"
                    }
                } catch let e as NSError {
                    print(e.localizedDescription)
                }
            }
        }
        task.resume()
    }
}
