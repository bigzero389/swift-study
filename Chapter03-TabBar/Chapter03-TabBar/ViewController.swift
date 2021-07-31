//
//  ViewController.swift
//  Chapter03-TabBar
//
//  Created by bigzero on 2021/07/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let tabBar = self.tabBarController?.tabBar
//        tabBar?.isHidden = (tabBar?.isHidden==true) ? false : true
        UIView.animate(withDuration: TimeInterval(0.15)) {
            tabBar?.alpha = ( tabBar?.alpha == 0 ? 1 : 0)
        }
    }
}

