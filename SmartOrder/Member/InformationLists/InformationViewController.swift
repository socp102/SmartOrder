//
//  InformationViewController.swift
//  SmartOder
//
//  Created by kimbely on 2018/11/27.
//  Copyright © 2018 kimbely. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices
import Firebase
import FirebaseDatabase

class InformationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate ,UITableViewDelegate ,UITableViewDataSource{
    
    let communicator = FirebaseCommunicator.shared
    
    
    @IBOutlet weak var InformationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        InformationTableView.delegate = self
        InformationTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        // 詢問使用者取用相簿授權
        PHPhotoLibrary.requestAuthorization { (status) in
            print("PHPhotoLibrary.requestAuthorization:\(status.rawValue)")
        }
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            return
        }
        update(currentUserUid: currentUserUid)
    }
    
    @IBOutlet weak var Photo: UIButton!
    @IBAction func takePicture(_ sender: Any) {
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
            let resizedImage = originalImage.resize(maxEdge: 1024)!
            
            //上傳照片
            
            guard let currentUserUid = Auth.auth().currentUser?.uid else {
                return
            }
            // 取得從 UIImagePickerController 選擇的檔案
            communicator.sendPhoto(selectedImageFromPicker: resizedImage, uniqueString: currentUserUid )
            
            update(currentUserUid: currentUserUid)
            
            
            
        } else if type == (kUTTypeMovie as String){
            
        }
        picker.dismiss(animated: true)//不加picker會凍結
    }
    
    func update(currentUserUid: String){
        //下載照片
        communicator.downloadImage(url: "AppCodaFireUpload/", fileName: "\(currentUserUid).jpeg") { (result, error) in
            if let error = error {
                self.Photo.setImage(UIImage(named: "camera"), for: .normal)
                print("download photo error:\(error)")
                
            } else {
                self.Photo.setImage((result as! UIImage), for: .normal)
            }
        }
        
        //下載資料
        communicator.loadData(collectionName: "account", documentName: currentUserUid) { (results, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                let results = results as! [ String : Any ]
                print("results:\(results)")
            }
        }
    }

    
    //TableView cell
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "InformationCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ResultTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
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
