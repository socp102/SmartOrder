//
//  InformationViewController.swift
//  SmartOder
//
//  Created by kimbely on 2018/11/27.
//  Copyright © 2018 kimbely. All rights reserved.
//

import UIKit

class InformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func takePicture(_ sender: Any) {
        
        
    }
    
    func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        show(imagePicker, sender: self)
        
        
    }
    
    //拍照時呼叫
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        dismiss(animated: true, completion: nil)
    }
    //從相簿裡挑
    func imagePhoto() {
        let imagePickerVC = UIImagePickerController()
        
        //設定來源為行動裝置
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        
        //設定顯示模式為popover
        imagePickerVC.modalPresentationStyle = .popover
        let popver = imagePickerVC.popoverPresentationController
        
        //popver?.sourceView =
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
