//
//  ViewController.swift
//  Chapter02-Button
//
//  Created by bigzero on 2021/07/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 버튼 인스턴스를 생성하고, 속성을 설정
        let btn = UIButton(type: UIButton.ButtonType.system)
        btn.frame = CGRect(x: 50, y: 100, width: 150, height: 30)
        btn.setTitle("테스트 버튼", for: UIControl.State.normal)
        
        btn.center = CGPoint(x: self.view.frame.size.width / 2, y: 100)
        
        // 루트뷰에 버튼을 추가한다.
        self.view.addSubview(btn)
        
        // 버튼의 이벤트와 메소드 btnOnClick(_:)을 연결한다.
        btn.addTarget(self, action: #selector(btnOnClick(_:)), for: .touchUpInside)
    }
    
    @objc func btnOnClick(_ sender: Any) {
        if let btn = sender as? UIButton {
            btn.setTitle("클릭되었습니다.", for: UIControl.State.normal)
        }
    }


}

