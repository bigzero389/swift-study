//
//  ControlViewController.swift
//  ControlViewController
//
//  Created by bigzero on 2021/07/25.
//

import UIKit
class ControlViewController :UIViewController {
    let slider = UISlider()
    
    override func viewDidLoad() {
        self.slider.minimumValue = 0
        self.slider.maximumValue = 100
        self.slider.frame = CGRect(x: 0, y: 0, width: 170, height: 30)
        self.view.addSubview(slider)
        self.preferredContentSize = CGSize(width: self.slider.frame.width, height: self.slider.frame.height + 10)
        
    }
    
    var sliderValue: Float {
        return self.slider.value
    }
    
}
