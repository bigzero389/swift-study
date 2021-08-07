//
//  ListViewController.swift
//  ListViewController
//
//  Created by bigzero on 2021/08/02.
//

import UIKit

class ListViewController: UITableViewController {
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return 3
//        return super.tableView(tableView, numberOfRowsInSection: section)
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return super.numberOfSections(in: tableView)
//    }
    
    @IBOutlet var name: UILabel!
    @IBAction func edit(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
            // alert 오픈시 기존의 text 를 띄워줌
            alert.addTextField() {
                $0.text = self.name.text
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                let value = alert.textFields?[0].text
                let plist = UserDefaults.standard
                plist.set(value, forKey: "name")
                plist.synchronize()
                
                // alert 창에서 입력받은 값을 레이블에 적용시킨다.
                self.name.text = value
            }))
            self.present(alert, animated: false, completion: nil)
    }
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var married: UISwitch!
    @IBAction func changeGender(_ sender: UISegmentedControl) {
        let value = sender.selectedSegmentIndex
        let plist = UserDefaults.standard
        plist.set(value, forKey: "gender")
        plist.synchronize()
    }
    @IBAction func changeMarried(_ sender: UISwitch) {
        let value = sender.isOn
        let plist = UserDefaults.standard
        plist.set(value, forKey: "married")
        plist.synchronize()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            let alert = UIAlertController(title: nil, message: "이름을 입력하세요", preferredStyle: .alert)
//            // alert 오픈시 기존의 text 를 띄워줌
//            alert.addTextField() {
//                $0.text = self.name.text
//            }
//            
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
//                let value = alert.textFields?[0].text
//                let plist = UserDefaults.standard
//                plist.set(value, forKey: "name")
//                plist.synchronize()
//                
//                // alert 창에서 입력받은 값을 레이블에 적용시킨다.
//                self.name.text = value
//            }))
//            self.present(alert, animated: false, completion: nil)
//        }
    }
    
    override func viewDidLoad() {
        let plist = UserDefaults.standard
        self.name.text = plist.string(forKey: "name")
        self.married.isOn = plist.bool(forKey: "married")
        self.gender.selectedSegmentIndex = plist.integer(forKey: "gender")
        
    }
}
