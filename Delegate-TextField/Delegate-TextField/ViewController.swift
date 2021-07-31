//
//  ViewController.swift
//  Delegate-TextField
//
//  Created by bigzero on 2021/06/26.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var tf: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.tf.delegate = self
        
        self.tf.becomeFirstResponder()
        
        self.tf.placeholder = "값을 입력하세요"
        self.tf.keyboardType = UIKeyboardType.alphabet
        self.tf.keyboardAppearance = UIKeyboardAppearance.dark
        self.tf.returnKeyType = UIReturnKeyType.join    // 리턴키 타입은 Join (연결)
        self.tf.enablesReturnKeyAutomatically = true    // 리턴키 자동 활성화 On
        
        self.tf.borderStyle = UITextField.BorderStyle.line
        self.tf.backgroundColor = UIColor(white: 0.87, alpha: 1.0)
        self.tf.contentVerticalAlignment = .center
        self.tf.contentHorizontalAlignment = .center
        self.tf.layer.backgroundColor = UIColor.darkGray.cgColor
        self.tf.layer.borderWidth = 2.0
    }

    @IBAction func confirm(_ sender: Any) {
        self.tf.resignFirstResponder()  // 포커스를 제거해서 화면상에 가상 키보드를 제거한다.
    }
    @IBAction func input(_ sender: Any) {
        self.tf.becomeFirstResponder()  // 다시 입력 상태로...
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 편집이 시작됨")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("텍스트 필드의 편집이 시작되었슴")
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 내용이 삭제됨")
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("텍스트 필드의 내용이 \(string) 으로 변경됨")

        // 숫자변환이 안되면 문자 아니면 숫자
//        return Int(string) == nil ? true : false
        
        if Int(string) == nil {
            if (textField.text?.count)! + string.count > 10 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 리턴키가 눌러졌음")
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("텍스트 필드의 편집이 종료됨")
        return true
    }
    
}

