//
//  ViewController.swift
//  Scene-CustsomSegue
//
//  Created by bigzero on 2021/06/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "custom_segue") {
            NSLog("세그웨이가 곧 실행됩니다.: \(segue.identifier!)");
        } else if(segue.identifier=="action_segue") {
            NSLog("세그웨이가 곧 실행됩니다.: \(segue.identifier!)");
        } else {
            NSLog("알수 없는 세그임.");
        }

    }


}

