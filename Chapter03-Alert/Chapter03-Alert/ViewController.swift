//
//  ViewController.swift
//  Chapter03-Alert
//
//  Created by bigzero on 2021/07/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let defaultAlertBtn = UIButton(type: .system)
        defaultAlertBtn.frame = CGRect(x: 0, y: 100, width: 100, height: 30)
        defaultAlertBtn.backgroundColor = UIColor.gray
        defaultAlertBtn.center.x = self.view.frame.width / 2
        defaultAlertBtn.setTitle("기본알림창", for: .normal)
        defaultAlertBtn.addTarget(self, action: #selector(defaultAlert(_:)), for: .touchUpInside)
        self.view.addSubview(defaultAlertBtn)
        
    }
    
    @objc func defaultAlert(_ sender: Any) {
//        let alert = UIAlertController(title: "알림창", message: "기본메시지가 들어가는 곳", preferredStyle: .alert)
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        let v = UIViewController()
        v.view.backgroundColor = UIColor.red
        alert.setValue(v, forKey: "contentViewController")
        
        self.present(alert, animated: true, completion: nil)
    }


}

