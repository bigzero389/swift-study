//
//  ViewController.swift
//  Scene-Trans01
//
//  Created by bigzero on 2021/06/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func moveNext(_ sender: Any) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main);
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") else {
            return;
        }
        
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        
        self.present(uvc, animated: true);
    }
    

}

