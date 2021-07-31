//
//  SideBarViewController.swift
//  SideBarViewController
//
//  Created by bigzero on 2021/07/31.
//

import UIKit

// 햄버거버튼 클릭시 좌에서 우로 펼쳐질 사이드메뉴 화면
class SideBarViewController : UITableViewController {
    
    let titles = [
        "Menu 01",
        "Menu 02",
        "Menu 03",
        "Menu 04",
        "Menu 05"
    ]
    
    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png")
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "menucell"
        var cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        // let cell = UITableViewCell() // 데이터가 많지 않아서 굳이 캐싱하지 않는 경우
        
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let accountLabel = UILabel()
        accountLabel.frame = CGRect(x: 10, y: 30, width: self.view.frame.width, height: 30)
        
        accountLabel.text = "bigzero@outlook.kr"
        accountLabel.textColor = UIColor.white
        accountLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70)
        v.backgroundColor = UIColor.brown
        v.addSubview(accountLabel)
        
        self.tableView.tableHeaderView = v
        
    }
}
