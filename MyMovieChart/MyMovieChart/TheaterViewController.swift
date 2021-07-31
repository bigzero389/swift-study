//
//  TheaterViewController.swift
//  MyMovieChart
//
//  Created by bigzero on 2021/07/05.
//

import UIKit
import MapKit

class TheaterViewController: UIViewController {
    var param: NSDictionary!
    @IBOutlet var map: MKMapView!
    
    override func viewDidLoad() {
        self.navigationItem.title = self.param["상영관명"] as? String
        // 위경도 값 가져옴
        let lat = (param?["위도"] as! NSString).doubleValue
        let lng = (param?["경도"] as! NSString).doubleValue
        // 현재 위치값 셋팅
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        // 지도에 표현될 거리 100m
        let regionRadius: CLLocationDistance = 100
        // 거기를 반영한 지역정보를 조합한 지도데이터 생성
        let coordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        // Map 에 표시
        self.map.setRegion(coordinateRegion, animated: true)
        
        // 지도에 위치값을 태그함
        let point = MKPointAnnotation()
        point.coordinate = location
        self.map.addAnnotation(point)
        
    }
}
