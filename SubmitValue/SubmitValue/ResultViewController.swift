//
//  ResultViewController.swift
//  SubmitValue
//
//  Created by bigzero on 2021/06/23.
//
import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var resultEmail: UILabel!
    @IBOutlet var resultUpdate: UILabel!
    @IBOutlet var resultInterval: UILabel!
    
    var paramEmail: String = "";
    var paramUpdate: Bool = false;
    var paramInterval: Double = 0;
    
    override func viewDidLoad() {
        self.resultEmail.text = paramEmail;
        self.resultUpdate.text = (self.paramUpdate == true ? "자동갱신" : "자동갱신안함");
        self.resultInterval.text = "\(Int(paramInterval))분 마다 갱신";
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true);
    }
}
