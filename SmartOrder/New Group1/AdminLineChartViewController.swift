//
//  AdminChartViewController.swift
//  SmartOrder
//
//  Created by 9S on 2018/11/26.
//  Copyright © 2018 Eason. All rights reserved.
//

import UIKit
import Charts

class AdminLineChartViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var chartViewA: LineChartView!
    @IBOutlet weak var chartViewB: LineChartView!
    
    var circleColors: [UIColor] = []        // 所有節點顏色 All point color
    var chartDataDayDetil: [String] = []
    var chartDataDayData: [Int] = []
    var chartDataMonthDetil: [String] = []
    var chartDataMonthData: [Int] = []
    var type:[String] = []
    var timePart:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setChart(dataPoints: chartDataDayData,
                 data: chartDataDayDetil,
                 chartView: chartViewA)
        setChart(dataPoints: chartDataMonthData,
                 data: chartDataMonthDetil,
                 chartView: chartViewB)
    }
    
    func setChart (dataPoints: [Int],data: [String],chartView: LineChartView) {
        
        var dataEntries: [ChartDataEntry] = []
        
        //若沒有資料，顯示的文字
        chartView.noDataText = "無數據提供"
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(dataPoints[i]))
            dataEntries.append(dataEntry)
            circleColors.append(.cyan)
            
        }
        
        // 資料封裝 圖表走勢 左下圖表名
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "\(type[0])")
        type.remove(at: 0)
        
        let chartData = LineChartData(dataSets: [chartDataSet]) // 折線圖 一條線
        
        // 設置折線圖數據
        if chartViewA.data == nil {
            chartViewA.data = chartData
            
        } else {
            chartViewB.data = chartData
        }
        
        chartView.noDataText = "暫無數據"        // 無數據時提示字串
        chartView.chartDescription?.text = timePart   //折線圖描述文字(右下文字
        chartView.chartDescription?.textColor = #colorLiteral(red: 0.1215686277, green: 0.01176470611, blue: 0.4235294163, alpha: 1)    // color
        chartView.legend.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)     // 左下圖表名顏色
        chartView.animate(xAxisDuration: 1, yAxisDuration: 1)    // 動畫播放 各一秒
        chartDataSet.colors = [#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)] // 線條顏色 多個顏色會交替使用
        chartDataSet.lineWidth = 3 // 線條寬(預設1
        chartDataSet.highlightColor = #colorLiteral(red: 1, green: 0.1912166916, blue: 0.1243797896, alpha: 1)   // 十字線顏色
        chartView.setVisibleXRangeMaximum(7)    // 最大顯示量
        chartView.xAxis.labelPosition = .bottom // x軸文字置底
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: data) // x軸資料
        
    }
}
