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
    var defaultPList: NSDictionary!
    
    func setInitValue() {
        if let account = self.storageLocation.string(forKey: "selectedAccount") {
            self.account.text = account
            let customPList = "\(account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPList]).first!
            let data = NSMutableDictionary(contentsOfFile: clist)
            
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        } else {
            self.account.placeholder = "등록된 계정이 없습니다."
            self.gender.isEnabled = false
            self.married.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        if let defaultPListPath = Bundle.main.path(forResource: "UserInfo", ofType: "plist") {
            self.defaultPList = NSDictionary(contentsOfFile: defaultPListPath)
        }
            
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
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newAccount(_:)))
        self.navigationItem.rightBarButtonItems = [addBtn]
        
    }
    
    @IBAction func changeGender(_ sender: UISegmentedControl) {
//        let plist = UserDefaults.standard
//        plist.set(sender.selectedSegmentIndex, forKey: "gender")
//        plist.synchronize()
        let value = sender.selectedSegmentIndex
        let customPList = "\(self.account.text!).plist" // 읽어올 파일명
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPList]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
        
        data.setValue(value, forKey: "gender")
        data.write(toFile: plist, atomically: true)
    }
    
    @IBAction func changeMarried(_ sender: UISwitch) {
//        let plist = UserDefaults.standard
//        plist.set(sender.isOn, forKey: "married")
//        plist.synchronize()
        let value = sender.isOn
        let customPList = "\(self.account.text!).plist" // 읽어올 파일명
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let path = paths[0] as NSString
        let plist = path.strings(byAppendingPaths: [customPList]).first!
        let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
        
        data.setValue(value, forKey: "married")
        data.write(toFile: plist, atomically: true)
        
        print("custom plist = \(plist)")
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 && !(self.account.text?.isEmpty)! {
            let alert = UIAlertController(title: "", message: "이름을 입력하세요", preferredStyle: .alert)
            alert.addTextField() { $0.text = self.name.text }
            alert.addAction(UIAlertAction(title: "OK", style: .default){ (_) in
                let value = alert.textFields?[0].text
//                let plist = UserDefaults.standard
//                plist.setValue(alert.textFields?[0].text, forKey: "name")
//                plist.synchronize()
                let customPList = "\(self.account.text!).plist" // 읽어올 파일명
                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                let path = paths[0] as NSString
                let plist = path.strings(byAppendingPaths: [customPList]).first!
                let data = NSMutableDictionary(contentsOfFile: plist) ?? NSMutableDictionary(dictionary: self.defaultPList)
                
                data.setValue(value, forKey: "name")
                data.write(toFile: plist, atomically: true)
                
                self.name.text = value
            })
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    @objc func pickerDone(_ sender: Any) {
        self.view.endEditing(true)
        
        if let _account = self.account.text {
            let customPList = "\(_account).plist"
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let path = paths[0] as NSString
            let clist = path.strings(byAppendingPaths: [customPList]).first!
            let data = NSDictionary(contentsOfFile: clist)
        
            self.name.text = data?["name"] as? String
            self.gender.selectedSegmentIndex = data?["gender"] as? Int ?? 0
            self.married.isOn = data?["married"] as? Bool ?? false
        }
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
                
                let plist = self.storageLocation
                plist.set(self.accountList, forKey: "accountList")
                plist.set(account, forKey: "selectedAccount")
                plist.set("", forKey: "name")
                plist.set("", forKey: "gender")
                plist.set("", forKey: "married")
                plist.synchronize()
                
                self.gender.isEnabled = true
                self.married.isEnabled = true
                
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
        
        storageLocation.set(account, forKey: "selectedAccount")
        storageLocation.synchronize()
//        self.view.endEditing(true)
    }
}
