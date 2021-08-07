//
//  ListViewController.swift
//  ListViewController
//
//  Created by bigzero on 2021/08/04.
//

import UIKit
class ListViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var married: UISwitch!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var name: UILabel!
    @IBOutlet var account: UITextField!
//    var accountList = ["","bigzero@outlook.kr", "garack@gmail.com", "garack@outlook.com", "garack@naver.com", "ultrayoung@kakao.com"]
    var accountList = [String]()
    var storageLocation = UserDefaults.standard
    
    func setInitValue() {
        let plist = self.storageLocation
        if let account = plist.string(forKey: "account") {
            self.account.text = account
            self.name.text = plist.string(forKey: "name")
            self.married.isOn = plist.bool(forKey: "married")
            self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        }
    }
    
    override func viewDidLoad() {
        let picker = UIPickerView()
        picker.delegate = self
        self.account.inputView = picker
        
        // picker 에 툴바를 생성한다.
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: 0, height: 35)
        toolbar.barTintColor = UIColor.lightGray
        self.account.inputAccessoryView = toolbar
        
        // 버튼 우측정렬을 위한 공백버튼 생성
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem()
        done.title = "Done"
        done.target = self
        done.action = #selector(pickerDone)
        // 신규 계정 등록 버튼
        let new = UIBarButtonItem()
        new.title = "New"
        new.target = self
        new.action = #selector(newAccount(_:))
        
        toolbar.setItems([new,flexSpace, done], animated: true)
        
        // 기본 저장소 객체 불러오기
        self.setInitValue()
//        let plist = UserDefaults.standard
//        self.account.text = plist.string(forKey: "account")
//        self.name.text = plist.string(forKey: "name")
//        self.married.isOn = plist.bool(forKey: "married")
//        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let plist = UserDefaults.standard
        plist.set(sender.selectedSegmentIndex, forKey: "gender")
        plist.synchronize()
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
        let plist = UserDefaults.standard
        plist.set(sender.isOn, forKey: "married")
        plist.synchronize()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            let alert = UIAlertController(title: "", message: "이름을 입력하세요", preferredStyle: .alert)
            alert.addTextField() { $0.text = self.name.text }
            alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                let plist = UserDefaults.standard
                plist.setValue(alert.textFields?[0].text, forKey: "name")
                plist.synchronize()
                self.name.text = alert.textFields?[0].text
            })
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @objc func newAccount(_ sender: Any) {
        self.view.endEditing(true)  // 일단 열려 있으면 닫고
        let alert = UIAlertController(title: "새 계정을 입력하세요", message: nil, preferredStyle: .alert)
        alert.addTextField() {
            $0.placeholder = "ex) abc@email.com"
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(_) in
            if let account = alert.textFields?[0].text {
                self.accountList.append(account)
                self.account.text = account
                
                // 새로운 계정이 들어왔으므로 다른 부가정보들 초기화
                self.name.text = ""
                self.gender.selectedSegmentIndex = 0
                self.married.isOn = false
                
                let plist = UserDefaults.standard
                plist.set(account, forKey: "account")
//                plist.set(accountList, forKey: "accountList")
                plist.set("", forKey: "name")
                plist.set("", forKey: "gender")
                plist.set("", forKey: "married")
                plist.synchronize()
                
            }
        }))
        self.present(alert, animated: false, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.accountList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.accountList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let account = self.accountList[row]
        self.account.text = account
//        self.view.endEditing(true)
    }
}
