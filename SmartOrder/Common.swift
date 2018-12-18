//
//  Common.swift
//  SmartOrder
//
//  Created by Eason on 2018/11/4.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Firebase

class Common {
    static func showAlert(on: UIViewController, style: UIAlertController.Style, title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "確認", style: .default, handler: nil)], completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        on.present(alert, animated: true, completion: completion)
    }
}
