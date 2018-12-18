//
//  AdminSelectChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/11/26.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts
import Firebase



class AdminSelectChartViewController: UIViewController {

    @IBOutlet weak var datePickerValue: UIDatePicker!
    @IBOutlet weak var pickSetView: UIView!
    @IBOutlet weak var timeTypeLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var selectChartSegmented: UISegmentedControl!
    @IBOutlet weak var selectTypeSegmented: UISegmentedControl!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var chartView: BarChartView!
    @IBOutlet weak var imageView: UIImageView!
    
    var startTime = ""
    var endTime = ""
    
    var bigPack = [FireOrderData]()
    // 圖表資料 Chart Data
    var commodityCountData: [String: Int] = [:]
    var commoditySubtotalData: [String: Int] = [:]
    var commodityCountDataString: [String] = []  // 商品數量S
    var commodityCountDataInt: [Int] = []  // 商品數量I
    var commoditySubtotalDataString: [String] = []   // 商品小記S
    var commoditySubtotalDataInt: [Int] = []   // 商品小記I
    var totalDayDataString: [String] = []       // 日營收S and 日來客S
    var totalDayDataInt: [Int] = []             // 日營收I
    var totalMonthDataString: [String] = []     // 月營收S and 月來客S
    var totalMonthDataInt: [Int] = []           // 月營收I
    var peopleDayDataInt: [Int] = []            // 日來客I
    var peopleMonthDataInt: [Int] = []          // 月來客I

    var firebaseCommunicator = FirebaseCommunicator.shared  //firebase commonunicator
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DatePick日期限制
        datePickerValue.maximumDate = Date()
        todayData()
    }
    
    // 關閉DatePick畫面
    @IBAction func cancelPickViewBtn(_ sender: Any) {
        pickViewChange()
        timeTypeLabel.text = "" // 清空DatePick title
    }
    
    // Date Pick Chack Botton 時間確認 and 起始小於結束檢查
    @IBAction func chackDateTimeBtn(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: datePickerValue.date)
        
        // Title.Lable檢查
        if let timeSetType = timeTypeLabel.text {
            switch timeSetType {
            case "起始時間":
                if endTime != "" {
                    if formatter.date(from: endTime)! <
                        formatter.date(from: dateString)! {
                        showAlert(Message: "起始時間不得大於結束時間")
                        return
                    }
                }
                startLabel.text = dateString // 起始label
                timeTypeLabel.text = ""      // pickerTital 清空
                startTime = dateString       // 起始時間
            case "結束時間":
                if startTime != "" {
                    if formatter.date(from: startTime)! >
                        formatter.date(from: dateString)! {
                        showAlert(Message: "結束時間不得小於起始時間")
                        return
                    }
                }
                endLabel.text = dateString
                timeTypeLabel.text = ""
                endTime = dateString
            default:
                break
            }
            // 日期改變 資料清空
            if totalDayDataString.count != 0 {
                totalDayDataString = []
                commodityCountData = [:]
                commoditySubtotalData = [:]
                commodityCountDataString = []  // 商品數量S
                commodityCountDataInt = []  // 商品數量I
                commoditySubtotalDataString = []   // 商品小記S
                commoditySubtotalDataInt = []   // 商品小記I
                totalDayDataString = []       // 日營收S and 日來客S
                totalDayDataInt = []             // 日營收I
                totalMonthDataString = []     // 月營收S and 月來客S
                totalMonthDataInt = []           // 月營收I
                peopleDayDataInt = []            // 日來客I
                peopleMonthDataInt = []          // 月來客I
            }
            pickViewChange()    // 關閉PickView
            chartView.isHidden = false
        }
    }
    
    
    // StartTime設定Btn
    @IBAction func startTimeSetBtn(_ sender: UIButton) {
        pickViewChange()
        timeTypeLabel.text = "起始時間"
        chartView.isHidden = true
    }
    
    
    // EndTime設定Btn
    @IBAction func endTimeSetBtn(_ sender: UIButton) {
        pickViewChange()
        timeTypeLabel.text = "結束時間"
        chartView.isHidden = true
    }
    // DatePickView 畫面收放
    func pickViewChange () {
        if pickSetView.isHidden == true {
            pickSetView.isHidden = false
        } else {
            pickSetView.isHidden = true
        }
    }
    
    
    // 繪圖鈕 Chart Button
    @IBAction func chartStartBtn(_ sender: UIButton) {
        // 設定檢查 起始時間,結束時間,選項是否被點選
        if startTime == "" || endTime == "" || selectTypeSegmented.selectedSegmentIndex == -1 ||
            selectChartSegmented.selectedSegmentIndex == -1 {
            showAlert(Message: "時間或設定未選取")
            return
        }
        // 沒資料就去抓 反之繪圖
        if totalDayDataString.count == 0 {
            getData()   // 取資料
            loadingView.startAnimating()    // loadingView Start
        } else {
            self.chartStart()
        }
        
        
    }
    
    // Chart 頁面入口選擇
     func chartStart() {
        
        var chartType: String = ""
        switch selectChartSegmented.selectedSegmentIndex {
        case 0:
            chartType = "LineChartVC"
        case 1:
            chartType = "BarChartVC"
        case 2:
            chartType = "PieChartVC"
        default:
            print("not Action")
        }
        if chartType != "" {
            performSegue(
                withIdentifier: chartType, sender: nil)
        } else {
            print("performSegue Error")
        }
    }
    
    // 換頁帶資料
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier {
            
        case "LineChartVC":  // 折線圖
            if selectTypeSegmented.selectedSegmentIndex == 0 {
                let controller = segue.destination as! AdminLineChartViewController
                controller.chartDataDayDetil = totalDayDataString
                controller.chartDataDayData = totalDayDataInt
                controller.chartDataMonthDetil = totalMonthDataString
                controller.chartDataMonthData = totalMonthDataInt
                controller.title = "收入"
                controller.type = ["日收入", "月收入"]
                controller.timePart = "\(startTime) ~ \(endTime)"
            } else {
                let controller = segue.destination as! AdminLineChartViewController
                controller.chartDataDayDetil = totalDayDataString
                controller.chartDataDayData = peopleDayDataInt
                controller.chartDataMonthDetil = totalMonthDataString
                controller.chartDataMonthData = peopleMonthDataInt
                controller.title = "來客量"
                controller.type = ["日來客", "月來客"]
                controller.timePart = "\(startTime) ~ \(endTime)"
            }
        case "BarChartVC":  // 長條圖
            switch selectTypeSegmented.selectedSegmentIndex {
            case 0:
                let controller = segue.destination as! AdminBarChartViewController
                controller.chartDataDayDetil = totalDayDataString
                controller.chartDataDayData = totalDayDataInt
                controller.chartDataMonthDetil = totalMonthDataString
                controller.chartDataMonthData = totalMonthDataInt
                controller.title = "收入"
                controller.type = ["日收入", "月收入"]
            case 1:
                let controller = segue.destination as! AdminBarChartViewController
                controller.chartDataDayDetil = totalDayDataString
                controller.chartDataDayData = peopleDayDataInt
                controller.chartDataMonthDetil = totalMonthDataString
                controller.chartDataMonthData = peopleMonthDataInt
                controller.title = "來客數量"
                controller.type = ["日來客", "月來客"]
            case 2:
                let controller = segue.destination as! AdminBarChartViewController
                controller.chartDataDayDetil = commodityCountDataString
                controller.chartDataDayData = commodityCountDataInt
                controller.chartDataMonthDetil = commodityCountDataString
                controller.chartDataMonthData = commoditySubtotalDataInt
                controller.title = "商品銷售量"
                controller.type = ["商品售出量", "商品銷售額"]
            default:
                print("selectTypeSegmented Error")
                break
            }
            
        case "PieChartVC":  // 圓餅圖
                let controller = segue.destination as! AdminPieChartViewController
                controller.chartDataA = commodityCountData
                controller.timePart = "\(startTime) ~ \(endTime)"
                controller.title = "商品銷售量"
                controller.type = ["商品售出量", "銷售量前五"]
        default:
            print("prepare Error")
        }
    }
    
    
    // \(endLabel.text) 資料取得 包裝
     func getData() {
        let addStartTime = startTime + " 00:00:00"
        let addEndTime = endTime + " 23:59:59"
        
        firebaseCommunicator.loadData(collectionName: "order", greaterThanOrEqualTo: addStartTime, lessThanOrEqualTo: addEndTime) { (results, error) in
            if let error = error {
                print("error \(error)")
            } else {
                
                var count: Int = 0
                var name: String = ""
                var subtotal: Int = 0
                var tempPack = [FireOrderData]()
                
                // 資料拆解
                let t1 = results as! Dictionary<String, Any>
                for (_, v1) in t1 {
                    
                    var total: Int = 0
                    var timestamp = Timestamp ()
                    let commodity = [ProductModel] ()
                    var pack = FireOrderData(commodity: commodity, timestamp: timestamp, total: total)
                    
                    let t2 = v1 as! Dictionary<String, Any>
                    for (k2, v2) in t2 {
                        
                        switch k2 {
                        case "allOrder":
                            let t3 = v2 as! Dictionary<String, Any>
                            for (k3, v3) in t3 {    // 商品層
                                name = self.itemDecoder(input: k3)    // add
                                let t4 = v3 as! Dictionary<String, Any>
                                for (k4, v4) in t4 {    // 商品內層資料
                                    if k4 == "count" {
                                        count = Int(v4 as! String)!  // add
                                    }
                                    if k4 == "subtotal" {
                                        subtotal = Int(v4 as! String)!   // add
                                    }
                                }
                                // 組成物件
                                let product = ProductModel(name: name, count: count, subtotal: subtotal)
                                pack.commodity.append(product)  //產品
                                // 清空
                                name = ""
                                count = 0
                                subtotal = 0
                            }
                        case "timestamp":
                            timestamp = v2 as! Timestamp
                        case "total":
                            total = Int(v2 as! String)!
                        default:
                            break
                        }
                    }
                    pack.timestamp = timestamp
                    pack.total = total
                    
                    tempPack.append(pack)
                }
                // 以時間timestamp.seconds排序 降序
                self.bigPack = tempPack.sorted { (str1, str2) -> Bool in
                    return str1.timestamp.seconds < str2.timestamp.seconds
                }
                self.dataOperation(data: self.bigPack)  // 資料處理
            }
            // 跳頁 and 關閉loadinView
            self.loadingView.stopAnimating()
            if self.selectTypeSegmented.selectedSegmentIndex == -1 {
                print("no Action")
            } else {
                self.chartStart()
            }
        }
    }
    
    // Chart選擇 & 鎖定 (設定項
    @IBAction func selectTypeBtn(_ sender: UISegmentedControl) {
        switch selectTypeSegmented.selectedSegmentIndex {
        case 0:
            selectChartSegmented.setEnabled(true, forSegmentAt: 0)
            selectChartSegmented.setEnabled(true, forSegmentAt: 1)
            selectChartSegmented.setEnabled(false, forSegmentAt: 2)
        case 1:
            selectChartSegmented.setEnabled(true, forSegmentAt: 0)
            selectChartSegmented.setEnabled(true, forSegmentAt: 1)
            selectChartSegmented.setEnabled(false, forSegmentAt: 2)
        case 2:
            selectChartSegmented.setEnabled(false, forSegmentAt: 0)
            selectChartSegmented.setEnabled(true, forSegmentAt: 1)
            selectChartSegmented.setEnabled(true, forSegmentAt: 2)
        default:
            print("selectType Error")
        }
    }
    
    
    func showAlert (Message: String) {
        let alertController = UIAlertController(
            title: "提示",
            message: Message,   //帶入的訊息
            preferredStyle: .alert)
        // 建立[確認]按鈕
        let okAction = UIAlertAction(title: "確認", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
//                print("按下確認後的動作")
        })
        alertController.addAction(okAction)
        // 顯示提示框
        present(
            alertController, animated: true, completion: nil)
    }
    
}

extension AdminSelectChartViewController {
    
    func todayData () {
        // 設定日期顯示格式
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // 取得現在日期
        let timeString = dateFormatter.string(from: Date())
        startTime = timeString
        endTime = timeString
        getData()
        
        var tempIntArray = [Int]()
        var tempStringArray = [String]()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.chartStart()
            // 遞減排序
            let result = self.commodityCountData.sorted { (str1, str2) -> Bool in
                return str1.1 > str2.1
            }
            // 取前五
            for (k, v) in result {
                if tempIntArray.count < 5 {
                    tempIntArray += [v]
                    tempStringArray += [k]
                } else {
                    break
                }
            }
            
            self.imageView.isHidden = true
            self.setChart(dataPoints: tempIntArray,
                          data: tempStringArray,
                          chartView: self.chartView)
        }
    }
    
    
    func setChart(dataPoints: [Int],data: [String], chartView: BarChartView) {
        
        chartView.noDataText = "無數據提供"
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(dataPoints[i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "今日熱賣商品")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartView.data = chartData
        chartData.barWidth = 0.5
        chartDataSet.stackLabels = data
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data)
        chartDataSet.colors = ChartColorTemplates.colorful()
        chartView.xAxis.labelPosition = .bottom
        chartView.setVisibleXRangeMaximum(3)
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
        
    }
}

extension AdminSelectChartViewController {
    
    // 資料處理
    func dataOperation (data: [FireOrderData]) {
        
        for (i, v) in data.enumerated() {
           
            let commodity = v.commodity
            for c in commodity {
                let a = commodityCountData[c.name]
                let b = commoditySubtotalData[c.name]
                // 商品與商品售出量
                // 取得出值就加總 不存在就創造
                if a != nil {
                    commodityCountData[c.name] = c.count + a!
                } else {
                    commodityCountData[c.name] = c.count
                }
                // 商品售出額
                if b != nil {
                    commoditySubtotalData[c.name] = c.subtotal + b!
                } else {
                    commoditySubtotalData[c.name] = c.subtotal
                }
            }
            
            // 營收 income / 日 day & 來客數
            let day = timestampInString(timestamp: v.timestamp, type: "day")
            let dayLong = totalDayDataString.count
            if dayLong == 0 {
                totalDayDataString.append(day)
                totalDayDataInt.append(v.total)
                peopleDayDataInt.append(1)
            } else {
                if totalDayDataString[dayLong - 1] == day {         // 若相同加總
                    let d = totalDayDataInt [dayLong - 1]           //
                    totalDayDataInt[dayLong - 1] = (d + v.total)    // 值相加
                    peopleDayDataInt[dayLong - 1] += 1              // 數量加1
                } else {    // 日期不同 新加值
                    totalDayDataString += [day]
                    totalDayDataInt += [v.total]
                    peopleDayDataInt += [1]
                }
            }
            
            // 營收 income / 月 month & 來客數
            let month = timestampInString(timestamp: v.timestamp, type: "month")
            let monthLong = totalMonthDataString.count
            if monthLong == 0 {
                totalMonthDataString.append(month)
                totalMonthDataInt.append(v.total)
                peopleMonthDataInt.append(i)
            } else {
                if totalMonthDataString[monthLong - 1] == month {    // 若month相同加總
                    let m = totalMonthDataInt [monthLong - 1]
                    totalMonthDataInt[monthLong - 1] = (m + v.total)
                    peopleMonthDataInt[monthLong - 1] += 1
                } else {    // 日期不同 新加值
                    totalMonthDataString += [month]
                    totalMonthDataInt += [v.total]
                    peopleMonthDataInt += [i]
                }
            }
        }
        for (k, v) in commodityCountData {
            commodityCountDataString.append(k)
            commodityCountDataInt.append(v)
        }
        for (k, v) in commoditySubtotalData {
            commoditySubtotalDataString.append(k)
            commoditySubtotalDataInt.append(v)
        }
    }
    
    // 時間轉換 Time Change (timestamp to Date Strint)    type: day "MM/dd" or month "yyyy/MM"
    func timestampInString (timestamp : Timestamp, type: String) -> String {
        
        var tempTime: String = ""
        let time: Double = Double(timestamp.seconds)
        // 轉換時間
        let timeInterval:TimeInterval = TimeInterval(time)
        let date = Date(timeIntervalSince1970: timeInterval)
        // 格式化輸出
        let dformatter = DateFormatter()
        
        switch type {
        case "month":
            dformatter.dateFormat = "yyyy/MM"
            tempTime = dformatter.string(from: date)
        case "day":
            dformatter.dateFormat = "MM/dd"
            tempTime = dformatter.string(from: date)
        default:
            assertionFailure("Date String Type Error")
        }
        return tempTime
    }
    
    // 商品名轉換
    func itemDecoder(input: String) -> String {
        switch input {
        case "BeefHamburger":
            return "牛肉漢堡"
        case "ChickenHamburger":
            return "雞肉漢堡"
        case "PorkHamburger":
            return "豬肉漢堡"
        case "TomatoSpaghetti":
            return "紅醬義麵"
        case "PestoSpaghetti":
            return "青醬義麵"
        case "CarbonaraSpaghetti":
            return "白醬義麵"
        case "CheesePizza":
            return "起司披薩"
        case "TomatoPizza":
            return "番茄披薩"
        case "OlivaPizza":
            return "橄欖披薩"
        case "FiletMigon":
            return "牛菲力"
        case "RibeyeSteak":
            return "牛肋排"
        case "GrilledSteak":
            return "炙燒牛排"
        case "Macaron":
            return "馬卡龍"
        case "ChocolateCake":
            return "巧克力蛋糕"
        case "Sundae":
            return "聖代"
        default:
            return input
        }
    }
}

