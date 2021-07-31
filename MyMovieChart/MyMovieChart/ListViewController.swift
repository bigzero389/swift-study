//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by bigzero on 2021/06/27.
//

import UIKit

class ListViewController: UITableViewController {
    
//    var dataset = [
//        ("다크나이트", "영웅물에 철학에 음악까지 더해져 예술이 되다.", "2008-09-04", 8.95, "darknight.jpeg"),
//        ("호우시절", "때를 알고 내리는 좋은 비", "2009-10-08", 7.31, "rain.jpeg"),
//        ("말할 수 없는 비밀", "여기서 너까지 다섯 걸음", "2015-05-07", 9.19, "secret.jpeg")
//    ]
    var page = 1
    
    
    lazy var list : [MovieVO] = {
        var datalist = [MovieVO]()
        return datalist
    }()
    
    override func viewDidLoad() {
        self.callMovieAPI()
    }
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView:UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
//        let title = cell.viewWithTag(101) as? UILabel
//        let desc = cell.viewWithTag(102) as? UILabel
//        let opendate = cell.viewWithTag(103) as? UILabel
//        let rating = cell.viewWithTag(104) as? UILabel
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = String(describing: row.rating!)
        
        //썸네일 처리 - 비동기
        DispatchQueue.main.async(execute: {
            cell.thumbmail.image = self.getThumbnailImage(row)
        })
        
        NSLog("메소드 실행을 종료하고 셀을 리턴합니다.")
        // cell.textLabel 이 nil 이면 아무것도 하지 않고 넘어간다. -> type 1
//        cell.textLabel?.text = row.title
//        cell.detailTextLabel?.text = row.description
        
        // cell.textLabel 이 nil 이면 아무것도 하지 않고 넘어간다. -> type 2
//        if let lb = cell.textLabel {
//            lb.text = row.title
//        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("선택된 행은 \(indexPath.row)번째 행 입니다.")
    }
    
    // 더보기 버튼
    @IBOutlet var moreBtn: UIButton!
    
    // 더보기 버튼 - Action
    @IBAction func more(_ sender: Any) {
        self.page += 1
        
        self.callMovieAPI()
        
        self.tableView.reloadData()
    }
    
    func callMovieAPI() {
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=003,005,016&order=releasedateasc"
        
        let apiURI: URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        
        // 데이터전송 결과를 로그로 일단 출력
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? "데이터가 없습니다."
        NSLog("API Result=\( log )")
        
        // JSON 객체 파싱
        do {
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            // MovieVO 객체에 저장
            for row in movie {
                let r = row as! NSDictionary
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
                self.list.append(mvo)
                
                //썸네일 처리 - 비동기
                DispatchQueue.main.async(execute: {
                    mvo.thumbnailImage = self.getThumbnailImage(mvo)
                })
//                썸네일 처리 - 동기
//                let url: URL! = URL(string: mvo.thumbnail!)
//                let imageData = try! Data(contentsOf: url)
//                mvo.thumbnailImage = UIImage(data: imageData)
            }
            
            // 전체 데이터 카운트
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            
            // 전체 데이터와 list 의 count 가 같으면 더보기 버튼 hidden
            if (self.list.count >= totalCount) {
                self.moreBtn.isHidden = true
            }
        } catch {
            NSLog("Error")
        }
    }
    
    func getThumbnailImage(_ mvo: MovieVO) -> UIImage {
//        let mvo = self.list[index]
        
        if let savedImage = mvo.thumbnailImage {
            NSLog("cache 적중")
            return savedImage
        } else {
            //썸네일 처리
            NSLog("cache 없음")
            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            return UIImage(data: imageData)!
        }
    }
}
// MARK: - 화면 전환 시 값을 넘겨주기 위한 세그웨이 관련 처리
extension ListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 실행된 세그웨이의 식별자가 "segue_detail" 이라면
        if segue.identifier == "segue_detail" {
            let path = self.tableView.indexPath(for: sender as! MovieCell)
            
            let detailVC = segue.destination as? DetailViewController
            detailVC?.mvo = self.list[path!.row]
        }
    }
}
