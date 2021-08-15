//
//  MemoListVC.swift
//  MyMemory
//
//  Created by bigzero on 2021/07/16.
//

import UIKit

class MemoListVC: UITableViewController {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        let memo = MemoData()
        memo.title = "워크샵 준비 물품들"
        memo.contents = "라면, 양파, 감자, 파, 계란, 세제류, 생수, 탄산수, 워셔액, 비누, 치약, 칫솔, 수건, 라면, 양파, 감자, 파, 계란, 세제류, 생수, 탄산수, 워셔액, 비누, 치약, 칫솔, 수건"
        memo.regdate = Date()
        
        appDelegate.memolist.append(memo)
        
        let memo1 = MemoData()
        memo1.title = "워크샵 출발 전 챙겨야 할 것들"
        memo1.contents = "이동중 섭취물품들, 인원 체크 및 예약장소 재확인"
        memo1.regdate = Date(timeIntervalSinceNow: 3000)
        
        appDelegate.memolist.append(memo1)
        
        let memo2 = MemoData()
        memo2.title = "출발 전 체크 항목들"
        memo2.contents = "인원별 탑승 완료 여부 확인 및 각 이동 차량 점검"
        memo2.regdate = Date(timeIntervalSinceNow: 4000)
        
        appDelegate.memolist.append(memo2)
        
        let memo3 = MemoData()
        memo3.title = "워크샵 결과 정리"
        memo3.contents = "부족했던 점 : 워크샵 장소 이동 사이에 간격이 너무 길어 사람들의 주의가 분산됨"
        memo3.regdate = Date(timeIntervalSinceNow: 8000)
        
        appDelegate.memolist.append(memo3)
        
        if let revealVC = self.revealViewController() {
            let btn = UIBarButtonItem()
            btn.image = UIImage(named: "sidemenu.png")
            btn.target = revealVC
            btn.action = #selector(revealVC.revealToggle(_:))
            self.navigationItem.leftBarButtonItem = btn
            self.view.addGestureRecognizer(revealVC.panGestureRecognizer())
        }
            
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.memolist.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1. memolist 배열 데이터에서 주어진 행에 맞는 데이터를 꺼낸다.
        let row = self.appDelegate.memolist[indexPath.row]
        // 2. 이미지속성이 비어 있을 경우 "memoCell", 아니면 "memoCellWithImage"
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        // 3. 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달받음
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        // 4.memoCell 의 내용 구한다.
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        // 5. Date 타입의 날짜를 yyyy-MM-dd HH:mm:ss 로 포맷변경
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)
        // 6. cell 객체리턴
        return cell
    }
    
    // 해당 뷰 컨트롤러가 디바이스의 스크린에 출력될 때마다 호출된다.
    // 1. 다른 화면으로 이동했다가 다시 돌아온 경우
    // 2. 홈버튼을 눌러 앱이 백그라운드 모드로 내려갔다가 다시 활성화 되었을 때
    // 3. 기타 상황으로 뷰 컨트롤러가 스크린에 표시될 때
    // viewWillAppear -> 뷰컨트롤러가 화면에 표시됨 -> viewDidAppear
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        if ud.bool(forKey: UserInfoKey.tutorial) == false {
            let vc = self.instanceTutorialVC(name: "MasterVC")
            self.present(vc!, animated: false)
        }
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.appDelegate.memolist[indexPath.row]
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func initValue(_ sender: Any) {
        for keyName in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: keyName)
        }
    }
}
