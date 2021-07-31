//
//  ViewController.swift
//  Delegate-ImagePicker
//
//  Created by bigzero on 2021/06/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var imgView: UIImageView!

    @IBAction func pick(_ sender: Any) {
        // privacy 규정 확인 - info.plist
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        picker.delegate = self
        
        self.present(picker, animated: false)
        
    }
}
// MARK:- 이미지 피커 컨트롤러 델리게이트 메소드
extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: false, completion: { () in
            let alert = UIAlertController(title: "", message: "이미지 선택이 취소됨", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: {(_) in }))
            self.present(alert, animated: false)
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false) { () in
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imgView.image = img
        }
    }
}
// MARK:- 내비게비션 컨트롤러 델리게이트 메소드
extension ViewController: UINavigationControllerDelegate {
    
}
// MARK:- 텍스트필드 델리게이트 메소드
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        <#code#>
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        <#code#>
    }
}

