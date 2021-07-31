//
//  SecondViewController.swift
//  Scene-Trans01
//
//  Created by bigzero on 2021/06/21.
//

import UIKit
class SecondViewController: UIViewController {
    
    @IBAction func dismiss(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true)
    }
}
