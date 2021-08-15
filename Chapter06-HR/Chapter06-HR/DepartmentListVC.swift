//
//  DepartmentListVC.swift
//  DepartmentListVC
//
//  Created by bigzero on 2021/08/15.
//

import UIKit
class DepartmentListVC : UITableViewController {
    var departList: [(departCd: Int, departTitle: String, departAddr: String)]!
    
    let departDAO = DepartmentDAO()
    
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "부서 목록 \n" + " 총 \(self.departList.count) 개"
        
        // 2. navigation bar ui setting
        self.navigationItem.titleView = navTitle
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        // 3. when cell swifted, it changed edit-mode
        self.tableView.allowsSelectionDuringEditing = true
    }
    
    @objc func editing(_ sender: Any) {
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "신규부서등록", message: "신규부서를 등록해 주세요", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(tf) in tf.placeholder = "부서명" })
        alert.addTextField(configurationHandler: {(tf) in tf.placeholder = "주소" })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
            // 확인버튼 누르면 부서등록을 처리한다.
            let title = alert.textFields?[0].text
            let addr = alert.textFields?[1].text
            
            if self.departDAO.create(title: title!, addr: addr!) {
                self.departList = self.departDAO.find()
                self.tableView.reloadData()
                
                let navTitle = self.navigationItem.titleView as! UILabel
                navTitle.text = "부서 목록 \n" + " 총 \(self.departList.count)"
            } else {
                NSLog("!!! departDAO Create is failed!!!")
            }
        }))
        self.present(alert, animated: false)
    }
    
    override func viewDidLoad() {
        self.departList = self.departDAO.find()
        self.initUI()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.departList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.departList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DEPART_CELL")
        cell?.textLabel?.text = rowData.departTitle
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.text = rowData.departAddr
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 1. 삭제할 행의 departCd를 구한다.
        let departCd = self.departList[indexPath.row].departCd
        
        // 2. DB에서, 데이터소스에서, 그리고 테이블뷰에서 차례대로 삭제한다.
        if departDAO.remove(departCd: departCd) {
            self.departList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            NSLog("!!! departDAO Remove is failed!!!")
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let departCd = self.departList[indexPath.row].departCd
        
        let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "DEPART_INFO")
        
        if let _infoVC = infoVC as? DepartmentInfoVC {
            _infoVC.departCd = departCd
            self.navigationController?.pushViewController(_infoVC, animated: true)
        }
    }
    
}
