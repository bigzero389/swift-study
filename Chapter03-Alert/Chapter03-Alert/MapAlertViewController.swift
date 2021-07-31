//
//  MapAlertViewController.swift
//  MapAlertViewController
//
//  Created by bigzero on 2021/07/24.
//

import UIKit
import MapKit

class MapAlertViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alertBtn = UIButton(type: .system)
        alertBtn.frame = CGRect(x: 0, y: 150, width: 100, height: 30)
        alertBtn.center.x = self.view.frame.width / 2
        alertBtn.setTitle("Map Alert", for: .normal)
        alertBtn.addTarget(self, action: #selector(mapAlert(_:)), for: .touchUpInside)
        self.view.addSubview(alertBtn)
        
        let imageBtn = UIButton(type: .system)
        imageBtn.frame = CGRect(x: 0, y: 200, width: 100, height: 30)
        imageBtn.center.x = self.view.frame.width / 2
        imageBtn.setTitle("Image Alert", for: .normal)
        imageBtn.addTarget(self, action: #selector(imageAlert(_:)), for: .touchUpInside)
        self.view.addSubview(imageBtn)
        
        let slider = UIButton(type: .system)
        slider.frame = CGRect(x: 0, y: 250, width: 100, height: 30)
        slider.center.x = self.view.frame.width / 2
        slider.setTitle("Slider Alert", for: .normal)
        slider.addTarget(self, action: #selector(sliderAlert(_:)), for: .touchUpInside)
        self.view.addSubview(slider)
        
        let listBtn = UIButton(type: .system)
        listBtn.frame = CGRect(x: 0, y: 300, width: 100, height: 30)
        listBtn.center.x = self.view.frame.width / 2
        listBtn.setTitle("listBtn Alert", for: .normal)
        listBtn.addTarget(self, action: #selector(listAlert(_:)), for: .touchUpInside)
        self.view.addSubview(listBtn)

    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        print(">>> 선택된 행은 \(indexPath.row)입니다.")
    }
    
    @objc func mapAlert(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: "여기가 맞습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        // 커스텀 작업 - alert 창에 Map 띄우기
        let contentVC = MapKitViewController()
        alert.setValue(contentVC, forKeyPath: "contentViewController")
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func imageAlert(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: "이번 글의 평점은 다음과 같습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        let contentVC = ImageViewController()
        alert.setValue(contentVC, forKeyPath: "contentViewController")
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func sliderAlert(_ sender: Any) {
        let contentVC = ControlViewController()
        let alert = UIAlertController(title: nil, message: "이번 글의 평점을 입력해주세요", preferredStyle: .alert)
        alert.setValue(contentVC, forKeyPath: "contentViewController")
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (_) in
            print(">>> sliderValue = \(contentVC.sliderValue)")
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func listAlert(_ sender: Any) {
        let contentVC = ListViewController()
        contentVC.delegate = self // 자기자신을 delegate 로 지정?
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(contentVC, forKeyPath: "contentViewController")
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}
