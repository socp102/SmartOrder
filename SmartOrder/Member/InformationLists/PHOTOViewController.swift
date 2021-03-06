//
//  PHOTOViewController.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
import Firebase
import FirebaseDatabase

class PHOTOViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var pho = UIImage(named: "camera")
    let getphoto = Getphoto()
    let communicator = FirebaseCommunicator.shared
    var resizedImage = UIImage(named: "camera")
    override func viewDidLoad() {
        super.viewDidLoad()

        // 詢問使用者取用相簿授權
        PHPhotoLibrary.requestAuthorization { (status) in
            print("PHPhotoLibrary.requestAuthorization:\(status.rawValue)")
        }
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
//        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
//            self.load()
//        }
        load()
    }
    override func viewDidDisappear(_ animated: Bool) {
        resizedImage = UIImage(named: "camera")
    }
    
   
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func Picture(_ sender: UIButton) {
        //取得同意授權鈕
        let alert = UIAlertController(title: "Please chouse source:", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.launchPicker(sourse: .camera)
        }
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.launchPicker(sourse: .photoLibrary)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true)
        
    }
    
    @IBOutlet weak var Photo: UIButton!
    
    
    //相機
    func launchPicker(sourse: UIImagePickerController.SourceType) {
        //查看有無Sourse
        guard UIImagePickerController.isSourceTypeAvailable(sourse) else {
            print("Invalid source type")
            return
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.mediaTypes = [kUTTypeImage,kUTTypeMovie] as [String]
        picker.sourceType = sourse
        picker.allowsEditing = true // 編輯照片
        
        present(picker , animated: true)
    }
    static var selectedImageFromPicker: UIImage?
    //接收照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("info:\(info)")
        guard let type = info[.mediaType] as? String else {
            assertionFailure("Invalid type")
            return
        }
        if type == (kUTTypeImage as String){
            guard let originalImage = info[.originalImage] as? UIImage else {
                assertionFailure("originalImage is nil")
                return
            }
            resizedImage = originalImage.resize(maxEdge: 1024)!
            //上傳照片
            self.image.layer.masksToBounds = true
            self.image.layer.cornerRadius = self.image.frame.width/2
            self.image.image = resizedImage
            
            guard let currentUserUid = Auth.auth().currentUser?.uid else {
                print("uid is nil")
                return
            }
            // 取得從 UIImagePickerController 選擇的檔案
            updatapic(resizedImage:resizedImage!,currentUserUid:currentUserUid)
            print("uid: \(currentUserUid)")
            
        } else if type == (kUTTypeMovie as String){
            
        }
        
        picker.dismiss(animated: true)//不加picker會凍結
    }
    
    func updatapic(resizedImage:UIImage,currentUserUid:String)  {
        communicator.sendPhoto(selectedImageFromPicker: resizedImage, uniqueString: currentUserUid )
        print("uid: \(currentUserUid)")
    }
    
    func load() {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            print("uid is nil")
            return
        }
        if self.resizedImage ==  self.pho {
            communicator.downloadImage(url: "AppCodaFireUpload/", fileName: "\(currentUserUid).jpeg", isUpdateToLocal: true) {(result, error) in
                if let error = error {
                    print("download photo error:\(error)")
                } else {
                    let pho = (result as! UIImage)
                    self.image.layer.masksToBounds = true
                    self.image.layer.cornerRadius = self.image.frame.width/2
                    self.image.image = pho
                }
            }
        }else{
            
        }
        
    }
    
    
}
