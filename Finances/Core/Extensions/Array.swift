

import Foundation
import Charts

extension Array where Self.Element == PaymentObject {
    
    func exclusiveSort() -> [Element] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return self.sorted(by: {
        guard let first = dateFormatter.date(from: $0.date)?.timeIntervalSince1970, let second = dateFormatter.date(from: $1.date)?.timeIntervalSince1970 else { return false }
        return first < second })
    }
}

extension Array where Self.Element: BinaryInteger {
    
    func chartExtractor(_ name: String) -> [ChartDataEntry] {
    (0..<count).map {
        ChartDataEntry(x: Double($0), y: Double(self[$0]), data: name)
        }
    }
}
