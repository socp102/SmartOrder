//
//  AdminPieChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/12/4.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts

class AdminPieChartViewController: UIViewController {

    @IBOutlet weak var chartViewA: BarChartView!
    @IBOutlet weak var chartViewB: PieChartView!
    
    
    var chartDataA: [String: Int] = [:] // commodityCountData

    var type: [String] = []
    var timePart: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarChart(dataPoints: chartDataA, chartView: chartViewA)
        setPieChart(dataPoints: chartDataA, chartView: chartViewB)
    }
    
    // BarChart
    func setBarChart(dataPoints: [String: Int], chartView: BarChartView) {
        
        chartView.noDataText = "無數據提供"
        var dataEntries: [BarChartDataEntry] = []
        var tempName:[String] = []
        
        var count = 0
        for (k, v) in dataPoints {
            let dataEntry = BarChartDataEntry(x: Double(count), y: Double(v))
            tempName.append(k)
            dataEntries.append(dataEntry)
            count += 1
        }
        
        // 顯示的資料之內容與名稱（左下角所顯示的）
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "\(type[0])")
        type.remove(at: 0)
        let chartData = BarChartData(dataSet: chartDataSet)
        // 數據設定
        chartView.data = chartData
        
        // x軸敘述
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: tempName)
        // chartDataSet為彩色
        chartDataSet.colors = ChartColorTemplates.colorful()
        // x軸標籤換到下方
        chartView.xAxis.labelPosition = .bottom
        // 一次顯示數據最大量
        chartView.setVisibleXRangeMaximum(7)
        // 一個一個延遲顯現的特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        // 彈跳特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
        
    }
    
    
    // Pie Chart
    func setPieChart (dataPoints: [String: Int], chartView: PieChartView) {
        
        var dataEntries: [PieChartDataEntry] = []
        var chartDataB: [String: Int] = [:]
        
        // 遞減排序
        let result = dataPoints.sorted { (str1, str2) -> Bool in
            return str1.1 > str2.1
        }
        // 取前五
        for (k, v) in result {
            if chartDataB.count < 5 {
                chartDataB[k] = v
            }
        }
        
        for (k, v) in chartDataB {
            let dataEntry = PieChartDataEntry(value: Double(v), label: k)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = PieChartDataSet(values: dataEntries, label: "\(type[0])")
        type.remove(at: 0)
        // 設置顏色
        chartDataSet.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
        
        chartView.chartDescription?.text = timePart   //折線圖描述文字(右下文字
        chartView.chartDescription?.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)    // color
        // 折線第一段起始位置（越大離圓越遠
        chartDataSet.valueLinePart1OffsetPercentage = 0.8
        chartDataSet.valueLinePart1Length = 0.6 // 折線第一段長度比例
        chartDataSet.valueLinePart2Length = 0.3 // 折線第二段長度比例
        chartDataSet.xValuePosition = .outsideSlice // 標籤文字顯示在圓外
        chartDataSet.yValuePosition = .outsideSlice //數字顯示在圓外
        
        let chartData = PieChartData(dataSet: chartDataSet)
        chartData.setValueTextColor(.black) // 文字黑色
        // 延遲顯現特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        // 彈跳特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
        // 設置餅狀圖數據
        chartView.data = chartData
    }
    
}
