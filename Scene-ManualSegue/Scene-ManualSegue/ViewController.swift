//
//  ViewController.swift
//  Scene-ManualSegue
//
//  Created by bigzero on 2021/06/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func wind(_ sender: Any) {
        self.performSegue(withIdentifier: "ManualWind", sender:   self)
    }
    
}

