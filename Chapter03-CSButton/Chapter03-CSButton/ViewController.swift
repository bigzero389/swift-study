//
//  ViewController.swift
//  Chapter03-CSButton
//
//  Created by bigzero on 2021/07/25.
//

import UIKit

public enum CSButtonType {
    case rect
    case circle 
    
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let frame = CGRect(x: 30, y: 50, width: 150, height: 30)
//        let csBtn = CSButton(frame: frame)
        let csBtn = CSButton()
        csBtn.frame = CGRect(x: 30, y: 50, width: 150, height: 30)
        self.view.addSubview(csBtn)
        
        let rectBtn = CSButton(type: .rect)
        rectBtn.frame = CGRect(x: 30, y: 50, width: 150, height: 30)
        self.view.addSubview(rectBtn)
        
        let circleBtn = CSButton(type: .circle)
        circleBtn.frame = CGRect(x: 30, y: 100, width: 150, height: 30)
        self.view.addSubview(circleBtn)
//        circleBtn.style = .rect
        
    }


}

