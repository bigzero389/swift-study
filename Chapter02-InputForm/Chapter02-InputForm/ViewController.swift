//
//  ViewController.swift
//  Chapter02-InputForm
//
//  Created by bigzero on 2021/07/20.
//

import UIKit

class ViewController: UIViewController {
    var paramEmail: UITextField!
    var paramUpdate: UISwitch!
    var paramInterval: UIStepper!
    var txtUpdate: UILabel!
    var txtInterval: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // 폰트패밀리 목록을 출력해 본다.
//        let fonts = UIFont.familyNames
//        let fonts = UIFont.fontNames(forFamilyName: "Menlo")
//        for f in fonts {
//            print("\(f)")
//        }
        
        for family in UIFont.familyNames {
            print("\(family)")
            
            for names in UIFont.fontNames(forFamilyName: family) {
                print("== \(names)")
            }
        }
        
        self.navigationItem.title = "설정"
        
        let lblEmail = UILabel()
        lblEmail.frame = CGRect(x: 10, y:100, width: 100, height: 30)
        lblEmail.text = "email"
//        lblEmail.font = UIFont.systemFont(ofSize: 14)
        lblEmail.font = UIFont(name: "D2CodingBold", size: 20)
        self.view.addSubview(lblEmail)
        
        self.paramEmail = UITextField()
        self.paramEmail.frame = CGRect(x: 120, y:100, width: 200, height: 30)
        self.paramEmail.font = UIFont.systemFont(ofSize: 14)
        self.paramEmail.borderStyle = UITextField.BorderStyle.roundedRect
        self.paramEmail.autocapitalizationType = .none
        self.view.addSubview(self.paramEmail)
        
        // 자동갱신
        let lblUpdate = UILabel()
        lblUpdate.frame = CGRect(x: lblEmail.frame.origin.x, y:150, width:100, height: 30)
        lblUpdate.text = "자동갱신"
        lblUpdate.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(lblUpdate)
        
        self.paramUpdate = UISwitch()
        self.paramUpdate.frame = CGRect(x: 120, y:150, width: 50, height: 30)
        self.paramUpdate.setOn(true, animated: true)
        self.view.addSubview(self.paramUpdate)
        self.paramUpdate.addTarget(self, action: #selector(presentUpdateValue(_:)), for: .valueChanged)
        
        self.txtUpdate = UILabel()
        self.txtUpdate.frame = CGRect(x: 250, y:150, width: 100, height: 30)
        self.txtUpdate.font = UIFont.systemFont(ofSize: 12)
        self.txtUpdate.textColor = UIColor.red
        self.txtUpdate.text = "갱신함"
        self.view.addSubview(self.txtUpdate)
        
        let lblInterval = UILabel()
        lblInterval.frame = CGRect(x: lblEmail.frame.origin.x, y:200, width:100, height: 30)
        lblInterval.text = "갱신주기"
        lblInterval.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(lblInterval)
        
        self.paramInterval = UIStepper()
        self.paramInterval.frame = CGRect(x: 120, y:200, width: 50, height: 30)
        self.paramInterval.minimumValue = 0
        self.paramInterval.maximumValue = 100
        self.paramInterval.stepValue = 1
        self.paramInterval.value = 0
        self.view.addSubview(self.paramInterval)
        self.paramInterval.addTarget(self, action: #selector(presentIntervalValue(_:)), for: .valueChanged)
        
        self.txtInterval = UILabel()
        self.txtInterval.frame = CGRect(x: 250, y:200, width: 100, height: 30)
        self.txtInterval.font = UIFont.systemFont(ofSize: 12)
        self.txtInterval.textColor = UIColor.red
        self.txtInterval.text = "0분마다"
        self.view.addSubview(self.txtInterval)
        
        // 전송버튼
        let submitBtn = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(submit(_:)))
        self.navigationItem.rightBarButtonItem = submitBtn
    }

    @objc func presentUpdateValue(_ sender: UISwitch) {
        self.txtUpdate.text = (sender.isOn == true ? "갱신함" : "갱신하지 않음")
    }
    
    @objc func presentIntervalValue(_ sender: UIStepper) {
        self.txtInterval.text = ("\( Int(sender.value))분마다")
    }
    
    @objc func submit(_ sender: Any) {
        let rvc = ReadViewController()
        rvc.pEmail = self.paramEmail.text
        rvc.pUpdate = self.paramUpdate.isOn
        rvc.pInterval = Int(self.paramInterval.value)
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    

}

