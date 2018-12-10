//
//  Orderlist.swift
//  SmartOrder
//
//  Created by kimbely on 2018/12/11.
//  Copyright © 2018 Eason. All rights reserved.
//

import Foundation

struct Order {
    var itemName = Items.init(count: "", subject: "")
    var time:String = ""
    var total:String = ""
}

struct Items {
    var count:String
    var subject:String
    
}
