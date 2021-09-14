

import RealmSwift

class PaymentObject: Object {
    @objc dynamic var sum = 0
    @objc dynamic var category = ""
    @objc dynamic var name = ""
    @objc dynamic var date = ""
    @objc dynamic var type = ""
}

extension PaymentObject {
    func isAfterDate(_ minimumDate: Date) -> Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        guard let date = formatter.date(from: date) else { return false }
        return date > minimumDate
    }
}
