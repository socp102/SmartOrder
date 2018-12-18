//
//  AdminBarChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/12/4.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts


class AdminBarChartViewController: UIViewController {
    
    var chartDataDayDetil: [String] = []
    var chartDataDayData: [Int] = []
    var chartDataMonthDetil: [String] = []
    var chartDataMonthData: [Int] = []
    
    var type: [String] = []
    
    @IBOutlet weak var chartViewA: BarChartView!
    @IBOutlet weak var chartViewB: BarChartView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setChart(dataPoints: chartDataDayData, data: chartDataDayDetil, chartView: chartViewA)
        setChart(dataPoints: chartDataMonthData, data: chartDataMonthDetil, chartView: chartViewB)
        
    }
    
    func setChart(dataPoints: [Int],data: [String], chartView: BarChartView) {
        
        // 若沒有資料，顯示的文字
        chartViewA.noDataText = "無數據提供"
        // BarChartDataEntry.
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(dataPoints[i]))
            dataEntries.append(dataEntry)
        }
        
        // 顯示的資料之內容與名稱（左下角所顯示的）
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "\(type[0])")
        type.remove(at: 0)
        // 把dataSet轉換成可顯示的BarChartData
        let chartData = BarChartData(dataSet: chartDataSet)
        
        // A chartView有資料就給B顯示
        if chartViewA.data == nil {
            chartViewA.data = chartData
            
        } else {
            chartViewB.data = chartData
        }

        // x軸敘述
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data)
        // chartDataSet為彩色
        chartDataSet.colors = ChartColorTemplates.colorful()
        // x軸標籤換到下方
        chartView.xAxis.labelPosition = .bottom
        // 最大顯示量  Important!  BarChartView 需先有數據
        chartView.setVisibleXRangeMaximum(7)
        // 延遲顯現
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        // 彈跳特效
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInBounce)
        
    }
    
}
