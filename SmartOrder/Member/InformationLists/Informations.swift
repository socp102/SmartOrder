//
//  Informations.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/12.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation
import Firebase

struct Information {
    var name = ""
    var gender = ""
    var phoneNum = ""
    var email = ""
    var birthday = ""
}

class LoadData {
    let fireBase = FirebaseCommunicator.shared
    var loadinfo = ["":""]
    var information = Information()
    var object = [Information]()
    
    func load() -> [Any] {
        guard let currentUserUid = Auth.auth().currentUser?.uid else {
            return []
        }
        fireBase.loadData(collectionName: "account", documentName: currentUserUid) { (result, error) in
            if let error = error {
                print("error: \(error)")
            }else{
                let result = result as! [String:Any]
                self.loadinfo = result as! [String : String]
                
                self.information.birthday = self.loadinfo["Birthday"] ?? ""
                self.information.email = self.loadinfo["email"]!
                self.information.phoneNum = self.loadinfo["PhoneNumber"] ?? ""
                self.information.gender = self.loadinfo["Gender"] ?? ""
                self.information.name = self.loadinfo["name"] ?? ""
                
                self.object.append(self.information)
            }
            
        }
        return [self.object]
    }
    
}
