//
//  DatePickerViewController.swift
//  SmartOrder
//
//  Created by Eason on 2018/12/13.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func dataSelected(birthday: String)
}

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    var delegate: DatePickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 讓顯示的高度只顯示有內容的部分
    override func viewWillLayoutSubviews() {
        
        preferredContentSize = CGSize(width: 320, height: 162)
    }
    
    @IBAction func datePickerValueChange(_ sender: UIDatePicker) {
        let dateValue = DateFormatter()
        dateValue.dateFormat = "yyyy/MM/dd"
        print("\(dateValue.string(from: birthdayDatePicker.date))")
        let birthday = dateValue.string(from: birthdayDatePicker.date)
        delegate?.dataSelected(birthday: birthday)
        
    }
}
