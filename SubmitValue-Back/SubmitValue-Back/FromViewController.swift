//
//  FromViewController.swift
//  SubmitValue-Back
//
//  Created by bigzero on 2021/06/23.
//

import UIKit

class FromViewController : UIViewController {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var isUpdate: UISwitch!
    @IBOutlet var interval: UIStepper!
    
    @IBOutlet var isUpdateText: UILabel!
    @IBOutlet var intervalText: UILabel!
    
    
    @IBAction func onSwitch(_ sender: UISwitch) {
        isUpdateText.text = sender.isOn ? "갱신" : "안함"
    }
    
    @IBAction func onInterval(_ sender: UIStepper) {
        intervalText.text = "\(Int(interval.value))분 마다";
    }
    @IBAction func onSubmit(_ sender: Any) {
//        let preVC = self.presentingViewController;
//        guard let vc = preVC as? ViewController else {
//            return
//        }
        
//        vc.paramEmail = self.email.text
//        vc.paramUpdate = self.isUpdate.isOn
//        vc.paramInterval = self.interval.value
        
//        let ad = UIApplication.shared.delegate as? AppDelegate;
//
//        ad?.paramEmail = self.email.text;
//        ad?.paramUpdate = self.isUpdate.isOn;
//        ad?.paramInterval = self.interval.value;
        
        
        let ud = UserDefaults.standard;
        
        ud.set(self.email.text, forKey: "email");
        ud.set(self.isUpdate.isOn, forKey: "isUpdate");
        ud.set(self.interval.value, forKey: "interval");
        
        
        self.presentingViewController?.dismiss(animated: true);
        
        // Segueway 생성시 Presentation 을 fullscreen 으로 해야 preVC 의 viewWillAppear 가 호출된다.
        // 책에 해당 내용이 없다.
        
    }
}
