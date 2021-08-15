//
//  EmployeeListVC.swift
//  EmployeeListVC
//
//  Created by bigzero on 2021/08/15.
//

import UIKit
class EmployeeListVC : UITableViewController {
    
    var loadingImg: UIImageView!
    // 임계점에 도달했을 때 나타날 배경 뷰, 노란 원 형태
    var bgCircle: UIView!
    var empList: [EmployeeVO]!
    var empDAO = EmployeeDAO()
    
    func initUI() {
        let navTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        navTitle.numberOfLines = 2
        navTitle.textAlignment = .center
        navTitle.font = UIFont.systemFont(ofSize: 14)
        navTitle.text = "사원 목록 \n" + " 총 \(self.empList.count) 개"
        
        // 2. navigation bar ui setting
        self.navigationItem.titleView = navTitle
    }
    
    override func viewDidLoad() {
        self.empList = self.empDAO.find()
        self.initUI()
        // table view 하단에 공백 뷰 삽입코드
        let dummyView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.tableView.tableFooterView = dummyView
        
        // 당겨서 새로고침
        self.refreshControl = UIRefreshControl()
//        self.refreshControl?.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
        self.loadingImg = UIImageView(image: UIImage(named: "refresh"))
        self.loadingImg.center.x = (self.refreshControl?.frame.width)! / 2
        self.refreshControl?.tintColor = UIColor.clear
        self.refreshControl?.addSubview(self.loadingImg)
        self.refreshControl?.addTarget(self, action: #selector(pullToRefresh(_:)), for: .valueChanged)
        
        // 1. 배경뷰 초기화 및 속성설정
        self.bgCircle = UIView()
        self.bgCircle.backgroundColor = UIColor.yellow
        self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
        
        // 2. 배경뷰를 refreshControl 객체에 추가하고, 로딩 이미지를 제일 위로 올림
        self.refreshControl?.addSubview(self.bgCircle)
        self.refreshControl?.bringSubviewToFront(self.loadingImg)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤이 발생할 때마다 처리할 내용
        // 당긴거리 : 공식처럼 외우면 편함.
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        self.loadingImg.center.y = distance / 2
        
        // 당긴거리를 최전각도로 반환하여 로딩 이미지설정
        let ts = CGAffineTransform(rotationAngle: CGFloat(distance / 20))
        self.loadingImg.transform = ts
        
        // 배경뷰의 중심 좌표 설정
        self.bgCircle.center.y = distance / 2
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.bgCircle.frame.size.width = 0
        self.bgCircle.frame.size.height = 0
    }
    
    @objc func pullToRefresh(_ sender: Any) {
        self.empList = self.empDAO.find()
        self.tableView.reloadData()
        
        // 당겨서 새로고침 종료
        self.refreshControl?.endRefreshing()
        
        let distance = max(0.0, -(self.refreshControl?.frame.origin.y)!)
        UIView.animate(withDuration: 0.5) {
            self.bgCircle.frame.size.width = 80
            self.bgCircle.frame.size.height = 80
            self.bgCircle.center.x = (self.refreshControl?.frame.width)! / 2
            self.bgCircle.center.y = distance / 2
            self.bgCircle.layer.cornerRadius = (self.bgCircle?.frame.size.width)! / 2
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.empList.count
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowData = self.empList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EMP_CELL")
        cell?.textLabel?.text = rowData.empName + "(\(rowData.stateCd.desc()))"
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell?.detailTextLabel?.text = rowData.departTitle
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        return cell!
    }
    
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Input Employee", message: "Input new employee", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(tf) in tf.placeholder = "Employee Name" })
        
        // insert pickerView in contentViewController area
        let pickervc = DepartPickerVC()
        alert.setValue(pickervc, forKey: "contentViewController")
        
        // input employee button
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { (_) in
            // 확인버튼 누르면 부서등록을 처리한다.
            var param = EmployeeVO()
            param.departCd = pickervc.selectedDepartCd
            param.empName = (alert.textFields?[0].text)!
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            param.joinDate = df.string(from: Date())
            
            param.stateCd = EmpStateType.ING
            
            if self.empDAO.create(param: param) {
                self.empList = self.empDAO.find()
                self.tableView.reloadData()
                
                if let navTitle = self.navigationItem.titleView as? UILabel {
                    navTitle.text = "사원 목록 \n" + " 총 \(self.empList.count) 명"
                }
            } else {
                NSLog("!!! departDAO Create is failed!!!")
            }
        }))
        self.present(alert, animated: false)
    }
    
    @IBAction func editing(_ sender: Any) {
        if self.isEditing == false {
            self.setEditing(true, animated: true)
            (sender as? UIBarButtonItem)?.title = "Done"
        } else {
            self.setEditing(false, animated: true)
            (sender as? UIBarButtonItem)?.title = "Edit"
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 1. 삭제할 행의 departCd를 구한다.
        let empCd = self.empList[indexPath.row].empCd
        
        // 2. DB에서, 데이터소스에서, 그리고 테이블뷰에서 차례대로 삭제한다.
        if empDAO.remove(empCd: empCd) {
            self.empList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            NSLog("!!! empDAO Remove is failed!!!")
        }
    }
    
}
