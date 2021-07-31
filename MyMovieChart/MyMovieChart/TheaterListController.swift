//
//  TheaterListController.swift
//  MyMovieChart
//
//  Created by bigzero on 2021/07/04.
//

import UIKit

class TheaterListController: UITableViewController {
    
    var list = [NSDictionary]()
    var startPoint = 0
    
    override func viewDidLoad() {
        self.callTheaterAPI()
    }
    
    func callTheaterAPI() {
        let requestURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 10
        let type = "json"
        let urlObj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")

        do {
            // NSString 을 이용해서 API 를 호출하고 인코딩된 문자열로 받아온다(euc-kr)
            let stringdata = try NSString(contentsOf: urlObj!, encoding: 0x80_000_422)
            // euc-kr 을 utf 로 변환
            let encdata = stringdata.data(using:String.Encoding.utf8.rawValue)
            
            // 페이지 중간에 데이터 호출에러가 나오는 경우를 대비해서 do 문을 내부 호출과 분석으로 분리함.
            do {
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                
                for obj in apiArray! {
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                let alert = UIAlertController(title: "실패", message: "데이터 분석이 실패하였습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: {(_) in }))
                self.present(alert, animated: false, completion: nil)
            }
            
            // 읽어와야 할 다음 페이지의 데이터 시작위치 저장
            self.startPoint += sList
            
        } catch {
            let alert = UIAlertController(title: "실패", message: "데이터 호출이 실패하였습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: {(_) in }))
            self.present(alert, animated: false, completion: nil)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let obj = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tCell") as! TheaterCell
        cell.name?.text = obj["상영관명"] as? String
        cell.tel?.text = obj["연락처"] as? String
        cell.addr?.text = obj["소재지도로명주소"] as? String
        
        return cell
    }
    
    @IBAction func moreBtn(_ sender: Any) {
        self.callTheaterAPI()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segue_map") {
            let path = self.tableView.indexPath(for: sender as! UITableViewCell)
            let data = self.list[path!.row]
            (segue.destination as? TheaterViewController)?.param = data
        }
    }
}
