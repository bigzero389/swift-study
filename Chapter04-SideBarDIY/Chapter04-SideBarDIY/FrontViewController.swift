//
//  FrontViewController.swift
//  FrontViewController
//
//  Created by bigzero on 2021/07/31.
//

import UIKit

// 사용자가 맨 처음 보는 화면 즉, 좌측에 햄버거버튼만 있는 화면
class FrontViewController : UIViewController {
    var delegate: RevealViewController?
    
    @objc func moveSide(_ sender: Any) {
        if sender is UIScreenEdgePanGestureRecognizer {
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.delegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem {
            if self.delegate?.isSideBarShowing == false {
                self.delegate?.openSideBar(nil)
            } else {
                self.delegate?.closeSideBar(nil)
            }
        }
    }
    
    override func viewDidLoad() {
        let btnSideBar = UIBarButtonItem(
            image: UIImage(named: "sidemenu.png"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(moveSide(_:))
        )
        self.navigationItem.leftBarButtonItem = btnSideBar
        
        // 화면끝에서 다른 쪽으로 패닝하는 제스처를 정의
        let dragLeft = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(moveSide(_:)))
        dragLeft.edges = UIRectEdge.left
        self.view.addGestureRecognizer(dragLeft)
        
        let dragRight = UISwipeGestureRecognizer(target: self, action: #selector(moveSide(_:)))
        dragRight.direction = .left
        self.view.addGestureRecognizer(dragRight)
    }
}
