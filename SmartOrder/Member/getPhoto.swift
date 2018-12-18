//
//  getPhoto.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation
import Firebase

class Getphoto {
    let communicator = FirebaseCommunicator.shared
    
    func showname()->String{
        guard let currentUserUid = Auth.auth().currentUser else {
            return ""
        }
        
        guard let currentUsername = currentUserUid.displayName else {
            return ""
        }
        
        
        return currentUsername
    }
    
    func update() -> UIImage{
        var pho = UIImage(named: "camera")
       
        guard let currentUserUid = Auth.auth().currentUser else {
            print("currentUserUid is nil")
            return pho!
        }
        //下載照片
        communicator.downloadImage(url: "AppCodaFireUpload/", fileName: "\(currentUserUid.uid).jpeg", isUpdateToLocal: false) {(result, error) in
            if let error = error {
                print("download photo error:\(error)")
            } else {
                pho = (result as! UIImage)
                
            }
            
        }
        
       
        return pho!
    }
    
    
}
