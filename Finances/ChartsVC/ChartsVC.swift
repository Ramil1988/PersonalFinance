

import Foundation
import Charts

class ChartsVC: UIViewController, ChartViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var chartView: UIView!
    
    lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        
        chartView.rightAxis.enabled = false
        
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 12)
        yAxis.setLabelCount(6, force: false)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        yAxis.labelPosition = .outsideChart
        chartView.delegate = self
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 12)
        chartView.xAxis.labelTextColor = .black
        chartView.xAxis.axisLineColor = .black
        chartView.animate(xAxisDuration: 1.0)
        chartView.xAxis.valueFormatter = self
        return chartView
    }()
    
    var category: PaymentCategoryObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chartView.addSubview(lineChartView)
        let constraint = lineChartView.topAnchor.constraint(equalTo: chartView.topAnchor)
        constraint.priority = .defaultLow
        constraint.isActive = true
        NSLayoutConstraint.activate([
            lineChartView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor),
            lineChartView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor),
            lineChartView.trailingAnchor.constraint(equalTo: chartView.trailingAnchor)
        ])
        
        let height = UIScreen.main.bounds.height > 700 ? UIScreen.main.bounds.height / 1.7 : UIScreen.main.bounds.height / 2
        lineChartView.frame = CGRect(x: 0, y: 0, width: view.bounds.width / 1.1, height: height)
        setData()
        
    }

    func setData() {
        
        guard let paymentsObject = category?.paymentObjects else { return }
        let paymentObjectArray = Array(paymentsObject).exclusiveSort()

        let yValues: [ChartDataEntry] = (0..<paymentObjectArray.count).map {
            ChartDataEntry(x: Double($0), y: Double(paymentObjectArray[$0].sum), data: "Ramil")
        }
        
        let set1 = LineChartDataSet(entries: yValues, label: category?.name)
        
        set1.mode = .cubicBezier
        
        set1.lineWidth = 3
        set1.setColor(.black)
        set1.circleColors = [.red]
        set1.circleRadius = 4
        set1.fill = Fill(color: .black)
        set1.fillAlpha = 0.8
        set1.drawFilledEnabled = true
        set1.drawHorizontalHighlightIndicatorEnabled = false
        set1.highlightColor = .systemRed
        lineChartView.xAxis.setLabelCount(set1.count, force: true)
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
        lineChartView.frame = CGRect(x: 0, y: 0, width: CGFloat(data.entryCount * 100), height: lineChartView.bounds.height)
        
        if data.entryCount < 3 {
            lineChartView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: lineChartView.bounds.height)
        } else {
            lineChartView.frame = CGRect(x: 0, y: 0, width: CGFloat(data.entryCount * 100), height: lineChartView.bounds.height)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(data.entryCount * 100), height: chartView.bounds.height)
    }
}

extension ChartsVC: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard let paymentsObject = category?.paymentObjects else { return "" }
        let paymentObjectArray = Array(paymentsObject).exclusiveSort()
        return paymentObjectArray[Int(value) % paymentObjectArray.count].date
    }
}
